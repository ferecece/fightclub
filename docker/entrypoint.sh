#!/bin/bash
set -euo pipefail

cd /home/container || exit 1
mkdir -p resources htdocs logs

GTAC_URL="${GTAC_SERVER_URL:-https://gtaconnected.com/downloads/server/latest/linux}"

update_gtac_binary() {
    local tmp
    tmp="$(mktemp -d "${TMPDIR:-/var/tmp}/the-last-ballad-update.XXXXXX")"
    trap 'rm -rf "$tmp"' RETURN
    echo "[entrypoint] updating GTAC server from $GTAC_URL"
    curl -fL --retry 3 --retry-delay 2 "$GTAC_URL" -o "$tmp/server.tar.gz"
    mkdir -p "$tmp/extract"
    tar -xzf "$tmp/server.tar.gz" -C "$tmp/extract"
    if [ ! -f "$tmp/extract/Server" ]; then
        echo "[entrypoint] invalid GTAC archive" >&2
        return 1
    fi
    install -m 0755 "$tmp/extract/Server" ./Server
    if [ -f "$tmp/extract/libmozjs-60.so" ]; then
        install -m 0644 "$tmp/extract/libmozjs-60.so" ./libmozjs-60.so
    fi
}

if [ ! -x ./Server ] || [ ! -f ./libmozjs-60.so ]; then
    /opt/install-server.sh /home/container
fi

if [ "${GTAC_UPDATE_ON_START:-false}" = "true" ]; then
    update_gtac_binary
fi

if [ ! -f ./server.xml.template ]; then
    echo "[entrypoint] missing server.xml.template" >&2
    exit 1
fi

SERVER_NAME="${SERVER_NAME:-THE LAST BALLAD}"
SERVER_PORT="${SERVER_PORT:-22000}"
HTTP_PORT="${HTTP_PORT:-$SERVER_PORT}"
HTTP_SERVER="${HTTP_SERVER:-true}"
HTTP_URL="${HTTP_URL:-}"
MAX_PLAYERS="${MAX_PLAYERS:-32}"
GAME="${GAME:-gta:iv}"
GAMEMODE="${GAMEMODE:-Racing}"
IV_EPISODE="${IV_EPISODE:-2}"
IV_GAMEMODE="${IV_GAMEMODE:-6}"
IV_NATIVE_MULTIPLAYER="${IV_NATIVE_MULTIPLAYER:-true}"
SERVER_BROWSER="${SERVER_BROWSER:-true}"
SERVER_QUERY="${SERVER_QUERY:-true}"
SERVER_PASSWORD="${SERVER_PASSWORD:-}"
SERVER_WEBSITE="${SERVER_WEBSITE:-https://github.com/ferecece/the-last-ballad}"

export SERVER_NAME SERVER_PORT HTTP_PORT HTTP_SERVER HTTP_URL MAX_PLAYERS
export GAME GAMEMODE IV_EPISODE IV_GAMEMODE IV_NATIVE_MULTIPLAYER
export SERVER_BROWSER SERVER_QUERY SERVER_PASSWORD SERVER_WEBSITE

python3 - ./server.xml.template ./server.xml <<'PY'
import html
import os
import sys

source, target = sys.argv[1], sys.argv[2]
text = open(source, encoding="utf-8").read()
keys = [
    "SERVER_NAME", "SERVER_PORT", "HTTP_PORT", "HTTP_SERVER", "HTTP_URL",
    "MAX_PLAYERS", "GAME", "GAMEMODE", "IV_EPISODE", "IV_GAMEMODE",
    "IV_NATIVE_MULTIPLAYER", "SERVER_BROWSER", "SERVER_QUERY",
    "SERVER_PASSWORD", "SERVER_WEBSITE",
]
for key in keys:
    text = text.replace("{{" + key + "}}", html.escape(os.environ.get(key, ""), quote=True))
open(target, "w", encoding="utf-8").write(text)
PY

chmod +x ./Server
echo ":/home/container$ ./Server"
exec ./Server
