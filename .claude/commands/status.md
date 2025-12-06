# Check Project Status

Check the current status of the n8n development environment:

1. Run `docker compose ps` to show container status
2. Run `docker compose logs --tail=20 n8n` to show recent n8n logs
3. Run `docker compose logs --tail=10 postgres` to show recent PostgreSQL logs
4. Check if the n8n web interface is accessible at the configured port

Report the overall health of the development environment.
