# Set environment variables
set dotenv-load := true

N8N_PORT := env("N8N_PORT")
PSQL_USER := env("POSTGRES_USER")
CLIENT := env("CLIENT")
PROJECT := env("PROJECT")

# Run n8n
up:
    docker compose up -d
    @echo "n8n editor: http://localhost:{{N8N_PORT}}/home/workflows"

# Stop n8n
down:
    docker compose down

# Export workflows as JSON to ./workflows/
export:
    docker exec n8n-{{CLIENT}}-{{PROJECT}} n8n export:workflow --output=/home/node/.n8n/workflows

# Open an interactive PSQL console for the project DB
db workflow="postgres":
    docker exec -it postgres-{{CLIENT}}-{{PROJECT}} psql -U {{PSQL_USER}} -d {{workflow}}
