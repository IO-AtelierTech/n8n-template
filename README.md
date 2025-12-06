# n8n Local Development Template

A containerized n8n workflow automation setup with PostgreSQL and Python ORM support.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and Docker Compose
- [just](https://github.com/casey/just) - command runner
- [uv](https://github.com/astral-sh/uv) - Python package manager
- Python >= 3.13

## Quick Start

```bash
# 1. Clone and enter the project
git clone <repo-url>
cd n8n-template

# 2. Create environment file
cp .env.example .env
# Edit .env with your values (all fields required)

# 3. Start containers
just up

# 4. Create database tables
just db-update

# 5. Import default workflows
just import-flows

# 6. Open n8n
open http://localhost:5678
```

## First-Time Setup in n8n

1. Create an account when prompted
2. Go to **Settings > API** and generate an API key
3. Add the key to `.env` as `N8N_API_KEY` (for MCP integration)
4. Create a **Postgres credential**:
   - Host: `postgres`
   - Database: value of `POSTGRES_DB` from `.env`
   - User: value of `POSTGRES_USER` from `.env`
   - Password: value of `POSTGRES_PASSWORD` from `.env`
5. Update the default workflow's Postgres node to use your credential
6. Activate the workflow

## Common Commands

| Command | Description |
|---------|-------------|
| `just up` | Start n8n and PostgreSQL containers |
| `just down` | Stop all containers |
| `just export-flows` | Export workflows to `data/n8n/workflows/` |
| `just import-flows` | Import workflows from JSON files |
| `just db-update` | Create tables from SQLModel definitions |
| `just db-shell` | Open PostgreSQL console |

## Project Structure

```
.
├── data/n8n/workflows/   # Workflow JSON files (version controlled)
├── db/dummy-db/          # Database models and migrations
├── scripts/              # Utility scripts
├── docker-compose.yaml   # Container configuration
├── Justfile              # Command definitions
└── .env                  # Environment variables (DO NOT COMMIT)
```

## Workflow Version Control

Workflows are stored as JSON in `data/n8n/workflows/`. Before committing:

```bash
just export-flows
git add data/n8n/workflows/
git commit -m "update workflows"
```

## Adding a Database Model

1. Edit `db/dummy-db/models.py`:

```python
from sqlmodel import Field, SQLModel

class MyTable(SQLModel, table=True):
    id: int = Field(primary_key=True)
    name: str
```

2. Create the table:

```bash
just db-update
```

## Documentation

See [CLAUDE.md](./CLAUDE.md) for detailed technical documentation.

## License

MIT
