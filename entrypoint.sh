#!/bin/sh
set -e

if [ -n "$PORT" ]; then
  export N8N_PORT="$PORT"
  echo "N8N will start on port $N8N_PORT"
fi

exec /usr/local/bin/n8n