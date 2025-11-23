# Set environment variables
set dotenv-load := true

N8N_PORT := env("N8N_PORT")

# Run n8n
up:
    docker compose up -d
    @echo "n8n editor: http://localhost:{{N8N_PORT}}/workflow"

# Stop n8n
down:
    docker compose down

# Export workflows as JSON to ./workflows/
export:
    docker exec n8n-${CLIENT}-${PROJECT} n8n export:workflow --output=/home/node/.n8n/workflows
