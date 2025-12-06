# Create New Workflow Database Module

Help me create a new database module for a specific workflow.

Ask me:
1. What should the workflow/database be named?

Then:
1. Copy the structure from `db/default/` to `db/<workflow_name>/`
2. Update the `pyproject.toml` name to match the workflow
3. Update the root `pyproject.toml` to include the new workspace member
4. Create initial models if specified
5. Show commands to initialize the database:
   ```bash
   # Create the database in PostgreSQL
   just db-shell
   # In psql: CREATE DATABASE <workflow_name>;

   # Run initial migration
   just db-update <workflow_name>
   ```
