# Set environment variables
set dotenv-load := true

N8N_PORT := env("N8N_PORT")
PSQL_USER := env("POSTGRES_USER")
PSQL_DB := env("POSTGRES_DB")
CLIENT := env("CLIENT")
PROJECT := env("PROJECT")

default:
  @just --list

# Run n8n
up:
    docker compose up -d
    @echo "n8n editor: http://localhost:{{N8N_PORT}}/home/workflows"

# Stop n8n
down:
    docker compose down

# Export workflows as JSON to ./data/n8n/workflows/
export-flows:
    docker exec n8n-{{CLIENT}}-{{PROJECT}} n8n export:workflow --backup --output=/home/node/.n8n/workflows/
    ./scripts/rename-workflows.sh data/n8n/workflows

# Import workflows from JSON files in ./data/n8n/workflows/
import-flows:
    #!/bin/bash
    for f in data/n8n/workflows/*.json; do
        filename=$(basename "$f")
        echo "Importing: $filename"
        docker exec n8n-{{CLIENT}}-{{PROJECT}} n8n import:workflow --input="/home/node/.n8n/workflows/$filename"
    done

# Open an interactive PSQL console for the project DB
db-shell db=PSQL_DB:
    docker exec -it postgres-{{CLIENT}}-{{PROJECT}} psql -U {{PSQL_USER}} -d {{db}}

# Create database tables from SQLModel definitions (db name must match db/<db>/models.py)
db-update db=PSQL_DB:
    uv run -m db.{{db}}.engine {{db}}
