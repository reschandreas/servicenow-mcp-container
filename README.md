# ServiceNow MCP Server (NowAIKit) — Containerized

Containerized version of https://mcpservers.org/servers/aartiq/servicenow-mcp

## Build
```bash
docker build -t servicenow-mcp .
```

## Run (stdio — default, for MCP clients)
```bash
docker run -i --rm --env-file .env servicenow-mcp
```

## Run (HTTP — for network/remote use)
```bash
docker run -d -p 3000:3000 --env-file .env -e TRANSPORT=http servicenow-mcp
# health: curl http://localhost:3000/health
# authenticated call:
# curl -H "Authorization: Bearer $NOWAIKIT_API_KEY" http://localhost:3000/mcp
```

Set `NOWAIKIT_API_KEY` in `.env` to require a bearer token on all HTTP endpoints.

## docker compose
```bash
cp .env.example .env  # fill in credentials
docker compose up -d
```