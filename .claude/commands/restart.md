# Restart Development Environment

Restart the n8n development environment cleanly.

Steps:
1. Stop all containers: `just down`
2. Optionally remove volumes if a clean start is requested
3. Start containers: `just up`
4. Wait for services to be healthy
5. Verify n8n is accessible at the configured port
6. Report the status of all services
