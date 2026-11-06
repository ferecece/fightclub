# THE LAST BALLAD

Egg para importar en Pterodactyl.

Archivo:

```text
egg-the-last-ballad.json
```

Imagen pública:

```text
ghcr.io/ferecece/the-last-ballad:latest
```

El servidor usa GTA Connected con GTA IV: The Ballad of Gay Tony.

Startup:

```text
./Server
```

Stop:

```text
quit
```

El servidor necesita:

- allocation UDP para el juego
- allocation TCP para el HTTP interno, si se usa

Variables principales:

```text
SERVER_NAME
SERVER_WEBSITE=https://github.com/ferecece/the-last-ballad
HTTP_PORT
HTTP_SERVER
HTTP_URL
MAX_PLAYERS
GAME=gta:iv
IV_EPISODE=2
IV_GAMEMODE=6
IV_NATIVE_MULTIPLAYER=true
```

El binario GTAC se descarga desde la fuente oficial durante la instalación.
