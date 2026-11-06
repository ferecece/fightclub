# FIGHT CLUB

Servidor de peleas para **GTA IV: The Ballad of Gay Tony** usando **GTA Connected**.

La imagen de runtime se publica en:

```text
ghcr.io/ferecece/fightclub:latest
```

El servidor GTA Connected se descarga desde la fuente oficial en el momento de instalar o actualizar. El binario no se guarda en el repositorio.

## Estructura

```text
docker/          Imagen runtime, entrypoint e instalador
server/          Template del volumen del servidor
pterodactyl/     Egg de FIGHT CLUB
docs/            Desarrollo y despliegue
compose.yaml     Entorno local
```

## Desarrollo local

```bash
cp .env.example .env
docker compose up
```

El servidor queda en:

```text
22000/udp   juego
22000/tcp   HTTP interno
```

El contenedor usa TTY porque el servidor GTA Connected lo necesita.

Los amigos pueden editar scripts y recursos en:

```text
server/resources/
```

Después reinician el contenedor:

```bash
docker compose restart
```

## Recursos

El install descarga el recurso oficial `freeroam`. Los recursos nuevos van en:

```text
server/resources/<nombre>/
```

y se agregan en `server/server.xml.template`:

```xml
<resources>
    <resource src="freeroam" />
    <resource src="mi_resource" />
</resources>
```

## HTTP externo

GTA Connected puede servir los archivos de cliente desde un CDN externo:

```xml
<httpserver>false</httpserver>
<httpurl>https://cdn.example.com/</httpurl>
```

El CDN debe apuntar al contenido de:

```text
server/htdocs/
```

Solo se sirven archivos declarados como `type="client"`. Los scripts viajan por la red del juego.

## Deploy en Pterodactyl

1. Importar `pterodactyl/egg-fightclub.json`.
2. Crear el servidor con la imagen `ghcr.io/ferecece/fightclub:latest`.
3. Asignar allocation UDP para el juego.
4. Asignar allocation TCP para el HTTP si se usa el HTTP interno.
5. Configurar `SERVER_NAME`, `HTTP_PORT`, `HTTP_SERVER`, `HTTP_URL` y `MAX_PLAYERS`.
6. Instalar o reinstalar el servidor.

El startup es:

```text
./Server
```

El stop command es:

```text
quit
```

GTA Connected no usa `shutdown`. `stop` se interpreta como stop de un resource.

## Actualizaciones

El install script baja el servidor GTAC latest desde:

```text
https://gtaconnected.com/downloads/server/latest/linux
```

Conserva:

- `server.xml.template`
- `server/resources/`
- `server/htdocs/`
- `server/logs/`

Si `GTAC_UPDATE_ON_START=true`, el entrypoint reemplaza solo `Server` y `libmozjs-60.so` al arrancar.
