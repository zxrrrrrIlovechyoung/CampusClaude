docker run '
--env-file "$PSScriptRoot\.env" '
-d '
--name postgres-campusclaude '
-p 54320:5432 ' 
-e POSTGRES_PASSWORD=CampusClaudePostgres#
-v campusclaude-postgres-data:var/lib/postgressql/data '
--restart always '
postgres:16-bookworm
