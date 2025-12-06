# Debug Database Connection

Help diagnose database connection issues.

Steps:
1. Check if PostgreSQL container is running: `docker compose ps postgres`
2. Check PostgreSQL logs: `docker compose logs --tail=30 postgres`
3. Verify environment variables are loaded from `.env`
4. Test database connection using Python:
   ```bash
   uv run python -c "from db.default.engine import get_engine; e = get_engine('default'); print(e.connect())"
   ```
5. List existing databases: `just db-shell` then `\l`
6. Check if tables exist: `just db-shell` then `\dt`

Report any issues found and suggest fixes.
