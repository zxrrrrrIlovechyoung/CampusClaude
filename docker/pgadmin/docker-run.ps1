docker network create campus-network 2>$null

docker run -d `
--env-file "$PSscriptRoot\.env" `
--network campus-network `
--name pgadmin-campusclaude `
-p 8082:80 `
-v campusclaude-pgadmin-data:/var/lib/pgadmin `
--restart always `
dpage/pgadmin4:6.17
