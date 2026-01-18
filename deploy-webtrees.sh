#!/bin/bash
set -e

DOMAIN="add-your-domain-here"  # <-- CHANGE THIS to your test domain
NETWORK_NAME="web"
ROUTER_NAME=$(echo "$DOMAIN" | tr '.' '-' | tr '[:upper:]' '[:lower:]')
CONTAINER_NAME=$ROUTER_NAME-whoami

echo "=== [webtrees] Setting up webtrees-familytree-site for $DOMAIN ==="

# -------- CONFIG --------
APP_DIR="$HOME/apps/websites/$ROUTER_NAME"

# Validate DOMAIN
if [[ "$DOMAIN" == "add-your-domain-here" ]] || [[ -z "$DOMAIN" ]]; then
  echo "ERROR: DOMAIN is not set to a valid domain. Please update  DOMAIN to your actual domain in whoami-test-site-with-domain.sh"
  exit 1
fi

if [[ ! -d "$APP_DIR" ]]; then
  echo "Creating webtrees-familytree-site directory: $APP_DIR"
  mkdir -p "$APP_DIR"
else
  echo "webtrees-familytree-site directory already exists: $APP_DIR"
fi

# Write docker-compose.yml
cd "$APP_DIR"
echo "Writing docker-compose.yml"
cat > docker-compose.yml <<EOF
services:
  db:
    image: mariadb:10.11
    container_name: familytree-webtrees-db
    restart: unless-stopped
    env_file:
      - .env
    environment:
      MARIADB_ROOT_PASSWORD: ${MARIADB_ROOT_PASSWORD}
      MARIADB_DATABASE: webtrees
      MARIADB_USER: webtrees
      MARIADB_PASSWORD: ${MARIADB_PASSWORD}
    volumes:
      - ./db/data:/var/lib/mysql
    networks:
      - internal

  webtrees:
    image: ghcr.io/nathanvaughn/webtrees:latest
    container_name: familytree-webtrees-app
    restart: unless-stopped
    depends_on:
      - db
    env_file:
      - .env
    environment:
      WT_DB_HOST: db
      WT_DB_NAME: webtrees
      WT_DB_USER: webtrees
      WT_DB_PASSWORD: ${MARIADB_PASSWORD}
    volumes:
      - ./webtrees/data:/var/www/html/data
      - ./webtrees/media:/var/www/html/media
    labels:
          - "traefik.enable=true"
          # 🔑 tell Traefik which Docker network to use
          - "traefik.docker.network=web"
          # 🔑 HTTPS ROUTER
          - "traefik.http.routers.$ROUTER_NAME.rule=Host(\`$DOMAIN\`)"
          - "traefik.http.routers.$ROUTER_NAME.entrypoints=websecure"
          # 🔑 HTTP ROUTER
          - "traefik.http.routers.$ROUTER_NAME-http.rule=Host(\`$DOMAIN\`)"
          - "traefik.http.routers.$ROUTER_NAME-http.entrypoints=web"
          - "traefik.http.routers.$ROUTER_NAME-http.service=$ROUTER_NAME"
          - "traefik.http.routers.$ROUTER_NAME.tls=true"
          - "traefik.http.routers.$ROUTER_NAME.tls.certresolver=letsencrypt"
          # Service
          - "traefik.http.services.$ROUTER_NAME.loadbalancer.server.port=80"
    networks:
      - web
      - internal

networks:
  $NETWORK_NAME:
    external: true
  internal:
    driver: bridge
EOF

# Start the container
echo "Starting familytree-webtrees container..."
docker compose up -d

echo "=== [webtrees] familytree-webtrees-site deployed ==="
echo "Test with: https://$DOMAIN"
echo "Make sure your domain's DNS is pointing to this server's IP."
