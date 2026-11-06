#!/bin/bash
set -euo pipefail

TARGET="${1:-/mnt/server}"
TEMPLATE_URL="${SERVER_TEMPLATE_URL:-https://github.com/ferecece/fightclub/releases/latest/download/server-template.tar.gz}"
GTAC_URL="${GTAC_SERVER_URL:-https://gtaconnected.com/downloads/server/latest/linux}"
TMP="$(mktemp -d "${TMPDIR:-/var/tmp}/fightclub-install.XXXXXX")"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TARGET" "$TARGET/resources" "$TARGET/htdocs" "$TARGET/logs"

echo "[install] target: $TARGET"
echo "[install] GTAC server: $GTAC_URL"

if [ -f "$TARGET/server.xml.template" ]; then
    echo "[install] template already present, keeping it"
else
    echo "[install] template: $TEMPLATE_URL"
    CURL_ARGS=(-fL --retry 3 --retry-delay 2)
    if [ -n "${GITHUB_TOKEN:-}" ]; then
        CURL_ARGS+=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
    fi
    curl "${CURL_ARGS[@]}" "$TEMPLATE_URL" -o "$TMP/server-template.tar.gz"
    mkdir -p "$TMP/template"
    tar -xzf "$TMP/server-template.tar.gz" -C "$TMP/template"
    cp -a "$TMP/template/." "$TARGET/"
fi

if [ -f "$TARGET/Server" ]; then
    BACKUP="$TARGET/backups/pre-update-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP"
    echo "[install] backup: $BACKUP"
    for item in server.xml server.xml.template resources htdocs logs; do
        if [ -e "$TARGET/$item" ]; then
            cp -a "$TARGET/$item" "$BACKUP/"
        fi
    done
fi

echo "[install] downloading GTAC server"
curl -fL --retry 3 --retry-delay 2 "$GTAC_URL" -o "$TMP/gtac-server.tar.gz"
mkdir -p "$TMP/gtac"
tar -xzf "$TMP/gtac-server.tar.gz" -C "$TMP/gtac"

if [ ! -f "$TMP/gtac/Server" ]; then
    echo "[install] invalid GTAC archive: Server not found" >&2
    exit 1
fi

install -m 0755 "$TMP/gtac/Server" "$TARGET/Server"
if [ -f "$TMP/gtac/libmozjs-60.so" ]; then
    install -m 0644 "$TMP/gtac/libmozjs-60.so" "$TARGET/libmozjs-60.so"
fi

# Keep custom resources. Only refresh the official freeroam skeleton.
mkdir -p "$TARGET/resources"
if [ -d "$TMP/gtac/resources/freeroam" ]; then
    rm -rf "$TARGET/resources/freeroam"
    cp -a "$TMP/gtac/resources/freeroam" "$TARGET/resources/freeroam"
fi

mkdir -p "$TARGET/htdocs" "$TARGET/logs"

if [ "$(id -u)" = "0" ]; then
    chown -R "${PUID:-999}:${PGID:-988}" "$TARGET"
fi

echo "[install] done"
