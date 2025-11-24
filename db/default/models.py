from typing import Optional
from uuid import UUID

from sqlalchemy.dialects.postgresql import UUID as UUIDSA
from sqlmodel import Column, Field, SQLModel, text


class Timestamp(SQLModel, table=True):
    id: Optional[UUID] = Field(
        sa_column=Column(
            UUIDSA(as_uuid=True),
            server_default=text("gen_random_uuid()"),
            primary_key=True,
        )
    )
    readable_date: str
    day_of_week: str
