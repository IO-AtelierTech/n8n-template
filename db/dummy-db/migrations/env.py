import os
import sys
from pathlib import Path

from alembic import context
from sqlalchemy import engine_from_config, pool
from sqlmodel import SQLModel

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))

# Load .env from project root
root_env = ROOT / ".env"
if root_env.exists():
    from dotenv import load_dotenv

    load_dotenv(root_env)

from db.default.engine import build_database_url
from db.default.models import *  # noqa


def get_url():
    workflow = "default"
    return build_database_url(workflow)


def run_migrations_offline():
    url = get_url()
    context.configure(
        url=url,
        target_metadata=SQLModel.metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online():
    configuration = context.config.get_section(context.config.config_ini_section)
    configuration["sqlalchemy.url"] = get_url()

    connectable = engine_from_config(
        configuration,
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=SQLModel.metadata,
        )

        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
