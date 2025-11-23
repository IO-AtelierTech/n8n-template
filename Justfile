# Set environment variables
set dotenv-load := true

# Run n8n
up:
    docker compose up -d

# Stop n8n
down:
    docker compose down

# Export workflows as JSON to ./workflows/
export:
    docker exec n8n-${CLIENT}-${PROJECT} n8n export:workflow --output=/home/node/.n8n/workflows
