docker network create campus-network 2>$null

docker run `
--env-file "$PSScriptRoot\.env" `
-d `
--network campus-network `
--name postgres-campusclaude `
-p 54320:5432 `
-v campusclaude-postgres-data:/var/lib/postgresql/data `
--restart always `
postgres:16-bookworm
