# odoo19-stack

Instancia de Odoo 19 empaquetada con Docker. La base de datos es externa (compose de Postgres separado). Se incluyen módulos propios (`customs`, `ocas`) y ruta para Enterprise.

## Requisitos
- Docker y Docker Compose
- Base de datos PostgreSQL accesible en la red `odoo-net` (ver repositorio `postgres`)

## Estructura
```
docker-compose.yml     # Servicio web de Odoo con healthcheck y volúmenes nombrados
Dockerfile             # Imagen custom (instala deps y fija ODOO_VERSION)
config/odoo.conf       # Config base (addons_path, longpolling, límites)
addons/                # customs, ocas, enterprise (montado desde host)
.env.example           # Variables de entorno de ejemplo
.gitignore
```
Volúmenes creados dinámicamente a partir de `WEB_HOST` (`<WEB_HOST>-data` y `<WEB_HOST>-logs`).

## Puesta en marcha
1) Copia `.env.example` a `.env` y ajusta:
   - `ODOO_VERSION` y `WEB_IMAGE_NAME` si quieres otro tag.
   - Conexión a DB: `ODOO_DB_HOST=pg16`, `ODOO_DB_PORT`, `ODOO_DB_USER`, `ODOO_DB_PASSWORD`.
   - Puertos: `WEB_PORT`, `WEBSOCKET_PORT`.
   - Ruta a enterprise: `ADDONS_ENTERPRISE=/ruta/a/odoo-19`.
2) Construye y levanta:
   ```bash
   docker compose --env-file .env build web
   docker compose --env-file .env up -d --force-recreate web
   ```
3) Acceso: `http://localhost:${WEB_PORT}`. Healthcheck expuesto en `/web/health`.

## Notas de configuración
- `config/odoo.conf`: usa `longpolling_port` (no `http_longpolling_port`), añade/quita rutas de addons según existan. Parámetros de workers y límites en ese archivo.
- `docker-compose.yml`: logging con rotación `json-file`, healthcheck, restart `unless-stopped`, volúmenes nombrados. No se levanta Postgres aquí.
- `.gitignore`: excluye datos, logs, backups y `.env`.

## Múltiples instancias
Cambia `WEB_HOST`, `WEB_PORT`, `WEBSOCKET_PORT` y `ADDONS_ENTERPRISE` en un `.env` distinto; los volúmenes se nombran con `WEB_HOST` para no colisionar.
