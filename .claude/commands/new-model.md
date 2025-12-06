# Create New Database Model

Help me create a new SQLModel database model.

Ask me:
1. What should the model be named?
2. What fields should it have (name, type, constraints)?
3. Should it go in the default database or a specific workflow database?

Then:
1. Add the model to the appropriate `db/<workflow>/models.py`
2. Import it in the models file if needed
3. Show me the Alembic commands to generate and apply the migration:
   ```bash
   cd db/<workflow>
   uv run alembic revision --autogenerate -m "add <model_name> table"
   uv run alembic upgrade head
   ```
