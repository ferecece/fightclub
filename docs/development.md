# Desarrollo local

## Requisitos

- Docker y Docker Compose.
- Cliente GTA Connected.
- GTA IV con The Ballad of Gay Tony instalado en el cliente.

## Primer arranque

```bash
cp .env.example .env
docker compose up
```

El entrypoint descarga el servidor GTAC latest si falta. Después genera `server.xml` desde `server/server.xml.template`.

El contenedor necesita TTY. Ya está configurado en `compose.yaml`.

## Crear scripts

Todo va en:

```text
server/resources/
```

Ejemplo:

```text
server/resources/mi_modo/
    meta.xml
    server.js
    client.js
```

`meta.xml`:

```xml
<meta>
    <info author="tu_nombre" description="Mi modo de pelea" />
    <script src="server.js" type="server" language="javascript" />
    <script src="client.js" type="client" language="javascript" />
</meta>
```

Agregar el resource en `server/server.xml.template`:

```xml
<resources>
    <resource src="freeroam" />
    <resource src="mi_modo" />
</resources>
```

Reiniciar:

```bash
docker compose restart
```

## Variables

```text
SERVER_NAME
SERVER_PORT
HTTP_PORT
HTTP_SERVER
HTTP_URL
MAX_PLAYERS
GAME=gta:iv
IV_EPISODE=2
IV_NATIVE_MULTIPLAYER=true
```

## Archivos generados

No se commitean:

- `server/Server`
- `server/libmozjs-60.so`
- `server/server.xml`
- `server/resources/freeroam/`
- `server/htdocs/*`
- `server/logs/`
- `server/backups/`

## Actualizar el binario

Una vez:

```bash
GTAC_UPDATE_ON_START=true docker compose up
```

O reinstalar desde Pterodactyl.
