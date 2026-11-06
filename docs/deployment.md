# Deploy en Pterodactyl

## Importar egg

Panel de Pterodactyl:

1. Nests.
2. Import Egg.
3. Seleccionar `pterodactyl/egg-fightclub.json`.

## Crear servidor

- Imagen: `ghcr.io/ferecece/fightclub:latest`
- Juego: `gta:iv`
- Episodio: `2` (The Ballad of Gay Tony)
- Puerto de juego: allocation UDP/TCP.
- Puerto HTTP: allocation TCP.
- Variable `HTTP_PORT`: mismo puerto HTTP asignado.

El startup es:

```text
./Server
```

El stop command es:

```text
quit
```

## Instalación

El install script:

1. Descarga `server-template.tar.gz` desde el último release.
2. Descarga el servidor GTA Connected latest.
3. Extrae `Server` y `libmozjs-60.so`.
4. Conserva recursos custom, `htdocs` y `logs`.
5. Aplica `server.xml.template` al arrancar.

## HTTP externo

Para usar un CDN o playit:

```text
HTTP_SERVER=false
HTTP_URL=https://tu-cdn/
```

El CDN debe servir el contenido de `server/htdocs/`.

Si se usa el HTTP interno:

```text
HTTP_SERVER=true
HTTP_URL=
```

## Actualizar

1. Crear y pushear un tag `v*`.
2. Esperar que GitHub Actions termine.
3. En Pterodactyl, Reinstall.
4. Confirmar en consola:

```text
Server is now listening on port...
```

## Notas

- GTA Connected necesita TTY.
- El binario GTAC no está en la imagen.
- `GTAC_UPDATE_ON_START=true` actualiza solo el binario al arrancar.
- El cliente necesita GTA IV TBoGT instalado.
