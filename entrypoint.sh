#!/bin/sh

echo "=== Heroku n8n entrypoint ==="
echo "PATH=$PATH"
echo "Checking /docker-entrypoint.sh:" && ls -la /docker-entrypoint.sh 2>&1 || true
echo "Checking n8n:" && ls -la /usr/local/bin/n8n 2>&1 || true
echo "Checking node:" && which node 2>&1 || echo "node not in PATH"
echo "Checking tini:" && which tini 2>&1 || echo "tini not in PATH"
echo "Checking /usr/bin/env:" && ls -la /usr/bin/env 2>&1 || true
echo "=== End diagnostics ==="

set -e

if [ -n "$PORT" ]; then
  export N8N_PORT="$PORT"
  echo "N8N will start on port $N8N_PORT"
fi

if [ -n "$DATABASE_URL" ] && [ -z "$DB_POSTGRESDB_HOST" ]; then
  # Parse DATABASE_URL using pure POSIX parameter expansion
  # Format: postgres://user:password@host:port/database
  _url="$DATABASE_URL"

  # Strip scheme (everything up to and including "://")
  _url="${_url#*://}"

  # Split userinfo from hostpath at "@"
  _userinfo="${_url%%@*}"
  _hostpath="${_url#*@}"

  # Extract user and password
  _user="${_userinfo%%:*}"
  _password="${_userinfo#*:}"

  # Extract host:port and database
  _hostport="${_hostpath%%/*}"
  _database="${_hostpath#*/}"
  # Strip query string from database name
  _database="${_database%%\?*}"

  # Extract host and port
  _host="${_hostport%%:*}"
  _port="${_hostport#*:}"
  # Default to 5432 if no port specified
  case "$_port" in
    *[!0-9]*|"") _port="5432" ;;
  esac

  export DB_TYPE="postgresdb"
  export DB_POSTGRESDB_HOST="$_host"
  export DB_POSTGRESDB_PORT="$_port"
  export DB_POSTGRESDB_DATABASE="$_database"
  export DB_POSTGRESDB_USER="$_user"
  export DB_POSTGRESDB_PASSWORD="$_password"
  export DB_POSTGRESDB_SSL_ENABLED="${DB_POSTGRESDB_SSL_ENABLED:-true}"
  export DB_POSTGRESDB_SSL_REJECT_UNAUTHORIZED="${DB_POSTGRESDB_SSL_REJECT_UNAUTHORIZED:-false}"
fi

if [ "$DB_TYPE" = "postgresdb" ] || [ -n "$DATABASE_URL" ]; then
  export DB_POSTGRESDB_SCHEMA="${DB_POSTGRESDB_SCHEMA:-n8n}"
fi

# Start n8n
exec /docker-entrypoint.sh