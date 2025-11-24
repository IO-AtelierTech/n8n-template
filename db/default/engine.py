import os
from pathlib import Path

from dotenv import load_dotenv
from sqlmodel import SQLModel, create_engine, inspect

from . import models


def in_docker() -> bool:
    return os.getenv("IN_DOCKER", "").lower() == "true"


if not in_docker():
    root_env = Path(__file__).resolve().parents[2] / ".env"
    if root_env.exists():
        load_dotenv(root_env)
    host = "localhost"
else:
    host = os.getenv("POSTGRES_HOST", "postgres")


def build_database_url(workflow: str):
    user = os.getenv("POSTGRES_USER")
    password = os.getenv("POSTGRES_PASSWORD")
    port = os.getenv("POSTGRES_PORT", "5432")

    return f"postgresql+psycopg://{user}:{password}@{host}:{port}/{workflow}"


def get_engine(workflow: str):
    return create_engine(build_database_url(workflow), echo=True)


def init_db(workflow):
    SQLModel.metadata.create_all(get_engine(workflow))


if __name__ == "__main__":
    init_db("default")
