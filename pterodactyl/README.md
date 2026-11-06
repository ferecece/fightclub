# FIGHT CLUB

Egg para importar en Pterodactyl.

Archivo:

```text
egg-fightclub.json
```

Imagen pública:

```text
ghcr.io/ferecece/fightclub:latest
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
HTTP_PORT
HTTP_SERVER
HTTP_URL
MAX_PLAYERS
GAME=gta:iv
IV_EPISODE=2
IV_NATIVE_MULTIPLAYER=false
```

El binario GTAC se descarga desde la fuente oficial durante la instalación.
