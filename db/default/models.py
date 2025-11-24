import uuid

from sqlmodel import Field, SQLModel


class Timestamp(SQLModel, table=True):
    id: uuid.UUID = Field(
        primary_key=True, sa_column_kwargs={"server_default": "gen_random_uuid()"}
    )
    readable_date: str
    day_of_week: str
    timezone: str | None = None  # <— new field
