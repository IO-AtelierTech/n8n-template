# n8n Local Development Template

## Project Overview

This is a local development template for **n8n** (workflow automation platform) with integrated PostgreSQL database support and Python ORM layer. It serves as a starting point for n8n projects requiring:

- Local containerized n8n instance
- PostgreSQL database for custom data
- Python-based database management with SQLModel/Alembic migrations
- Workflow export and management

## Tech Stack

| Component | Technology | Notes |
|-----------|------------|-------|
| Workflow Engine | n8n | latest Docker image |
| Database (Custom) | PostgreSQL 18 | For application data |
| Database (n8n internal) | SQLite | Embedded in n8n |
| Python ORM | SQLModel | SQLAlchemy + Pydantic |
| Migrations | Alembic | Schema versioning |
| Python | >= 3.13 | Required version |
| Package Manager | uv | Fast Python packages |
| Task Runner | just | Command automation |

## Project Structure

```
.
├── docker-compose.yaml     # n8n + PostgreSQL containers
├── Justfile                # Task runner commands
├── pyproject.toml          # Root Python workspace
├── .env                    # Environment variables (DO NOT COMMIT)
├── .env.example            # Template for .env
├── .mcp.json               # MCP server config (Claude Code)
├── data/
│   ├── n8n/                # n8n data (workflows, sqlite, logs)
│   │   └── workflows/      # JSON workflow templates
│   └── psql/               # PostgreSQL data volume
└── db/
    └── dummy-db/           # Example database module
        ├── engine.py       # Database connection logic
        ├── models.py       # SQLModel table definitions
        ├── alembic.ini     # Migration configuration
        └── migrations/     # Alembic migrations
```

## Common Commands

```bash
just up          # Start n8n and PostgreSQL containers
just down        # Stop all containers
just export      # Export workflows to ./data/n8n/workflows/
just import      # Import workflows from JSON files
just db-shell    # Open PostgreSQL console (dummy-db)
just db-shell <db>  # Open specific database
just db-update   # Create tables from SQLModel definitions
```

## Environment Variables

Required in `.env`:
- `CLIENT` - Client identifier (used in container names)
- `PROJECT` - Project identifier
- `N8N_PORT` - n8n web interface port (default: 5678)
- `POSTGRES_USER` - PostgreSQL username
- `POSTGRES_PASSWORD` - PostgreSQL password
- `POSTGRES_DB` - Default database name (default: dummy-db)
- `N8N_API_KEY` - API key for n8n MCP (optional)

## Database Layer

### Adding Models

Edit `db/dummy-db/models.py`:

```python
from sqlmodel import Field, SQLModel

class MyModel(SQLModel, table=True):
    id: int = Field(primary_key=True)
    name: str
```

### Creating Tables

```bash
just db-update
```

### Creating Migrations (for schema changes)

```bash
cd db/dummy-db
uv run alembic revision --autogenerate -m "add my_model table"
uv run alembic upgrade head
```

## Workflow Management

### Default Workflow

The template includes `default-flow.json` - a cron-triggered workflow that logs timestamps to PostgreSQL every 5 minutes.

**First-time setup:**
1. Run `just up` to start containers
2. Run `just db-update` to create the `timestamp` table
3. Run `just import` to import the workflow
4. In n8n, create a Postgres credential with:
   - Host: `postgres`
   - Database: `dummy-db`
   - User/Password: from `.env`
5. Update the workflow's Postgres node with your credential
6. Activate the workflow

### Fresh Start (for template)

The `database.sqlite` is gitignored, so pushing to GitHub gives users a fresh n8n instance. Workflows are stored as JSON in `data/n8n/workflows/` and imported via `just import`.

## n8n Configuration

Key environment settings in docker-compose.yaml:
- Python enabled (`N8N_PYTHON_ENABLED=true`)
- Community packages enabled
- All execution data saved (7 days retention)
- Telemetry disabled (development mode)
- PostgreSQL env vars available in nodes

## Multi-Database Support

Create additional database modules under `db/`:
```
db/
├── dummy-db/    # Default example database
├── users/       # User data database
└── analytics/   # Analytics database
```

Each can have its own models and migrations.

## URLs

- n8n Editor: `http://localhost:{N8N_PORT}/home/workflows`
- PostgreSQL: `localhost:5432`

## MCP Integration (Claude Code)

The template includes n8n MCP configuration in `.mcp.json`:
- Requires `N8N_API_KEY` in `.env`
- Enables workflow management via Claude Code
- Use `/mcp` to check connection status

## Git Workflow

**Before every commit**, run `just export-flows` to export n8n workflows to JSON. This ensures workflow changes are version-controlled.

```bash
just export-flows && git add data/n8n/workflows/ && git commit -m "your message"
```

## Development Tips

1. Always check container status: `docker compose ps`
2. View n8n logs: `docker compose logs -f n8n`
3. View PostgreSQL logs: `docker compose logs -f postgres`
4. **Export workflows before committing**: `just export-flows`
5. Use `just db-shell` to debug database issues
6. Credentials are stored in `database.sqlite` (gitignored)
