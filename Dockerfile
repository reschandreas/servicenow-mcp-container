# Dockerfile to run the ServiceNow MCP server (NowAIKit)
# https://mcpservers.org/servers/aartiq/servicenow-mcp
#
# Multi-stage build:
#   builder  -> installs the pinned npm release on Node 26 Alpine
#   runtime  -> Chainguard Node 26 image (minimal, non-root, daily-rebuilt)
#
# Default transport is stdio (MCP over stdin/stdout). Run with `-i`:
#   docker run -i --rm --env-file .env servicenow-mcp
#
# For a network/HTTP deployment, set TRANSPORT=http (or sse) and map the port:
#   docker run -d -p 3000:3000 --env-file .env -e TRANSPORT=http servicenow-mcp

# Pinned upstream version; bumped automatically by .github/workflows/update-nowaikit.yml
ARG NOWAIKIT_VERSION=5.1.0

# ---------- builder ----------
FROM node:26-alpine AS builder

ARG NOWAIKIT_VERSION
RUN npm install -g nowaikit@${NOWAIKIT_VERSION} \
    && npm cache clean --force

# ---------- runtime (Chainguard, non-root, Node 26) ----------
FROM cgr.dev/chainguard/node:latest

ARG NOWAIKIT_VERSION
ENV NOWAIKIT_VERSION=${NOWAIKIT_VERSION} \
    NODE_ENV=production \
    TRANSPORT=stdio \
    PORT=3000 \
    HOST=0.0.0.0 \
    NODE_PATH=/usr/local/lib/node_modules

COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules

WORKDIR /usr/local/lib/node_modules/nowaikit

EXPOSE 3000

CMD ["dist/server.js"]