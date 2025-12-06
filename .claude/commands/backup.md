# Backup Workflows and Data

Create a backup of the current n8n workflows and optionally the database.

Steps:
1. Run `just export` to export all workflows to JSON
2. Show the exported files in `./data/n8n/workflows/`
3. Ask if a PostgreSQL dump is also needed
4. If yes, run: `docker exec postgres-${CLIENT}-${PROJECT} pg_dump -U ${POSTGRES_USER} <database> > backup_<date>.sql`

Report what was backed up and where the files are located.
