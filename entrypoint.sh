#!/bin/sh
set -e

if [ -n "$PORT" ]; then
  export N8N_PORT="$PORT"
  echo "N8N will start on port $N8N_PORT"
fi

parse_database_url() {
  eval "$(echo "$1" | sed -e "s#^\(\(.*\)://\)\?\(\([^:@]*\)\(:\(.*\)\)\?@\)\?\([^/?]*\)\(/\(.*\)\)\?#N8N_DB_SCHEME='\2' N8N_DB_USER='\4' N8N_DB_PASSWORD='\6' N8N_DB_HOSTPORT='\7' N8N_DB_DATABASE='\9'#")"
}

if [ -n "$DATABASE_URL" ] && [ -z "$DB_POSTGRESDB_HOST" ]; then
  parse_database_url "$DATABASE_URL"

  DB_HOST="$(echo "$N8N_DB_HOSTPORT" | sed -e 's,:.*,,g')"
  DB_PORT="$(echo "$N8N_DB_HOSTPORT" | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"

  export DB_TYPE="postgresdb"
  export DB_POSTGRESDB_HOST="$DB_HOST"
  export DB_POSTGRESDB_PORT="$DB_PORT"
  export DB_POSTGRESDB_DATABASE="$N8N_DB_DATABASE"
  export DB_POSTGRESDB_USER="$N8N_DB_USER"
  export DB_POSTGRESDB_PASSWORD="$N8N_DB_PASSWORD"
  export DB_POSTGRESDB_SSL_ENABLED="${DB_POSTGRESDB_SSL_ENABLED:-true}"
  export DB_POSTGRESDB_SSL_REJECT_UNAUTHORIZED="${DB_POSTGRESDB_SSL_REJECT_UNAUTHORIZED:-false}"
fi

if [ "$DB_TYPE" = "postgresdb" ] || [ -n "$DATABASE_URL" ]; then
  export DB_POSTGRESDB_SCHEMA="${DB_POSTGRESDB_SCHEMA:-n8n}"
fi

exec /usr/local/bin/n8n