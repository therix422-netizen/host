# Offizielles OmniRoute Repo direkt aus GitHub bauen
FROM node:20-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends git python3 build-essential ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN git clone --depth 1 https://github.com/diegosouzapw/OmniRoute.git .

RUN npm install -g pnpm@9 || npm install -g pnpm
RUN (pnpm install --frozen-lockfile || pnpm install || npm install)
RUN (pnpm run build || npm run build || echo "no build step")

# Runtime
FROM node:20-slim
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=builder /app /app

ENV NODE_ENV=production
ENV PORT=8080
ENV HOST=0.0.0.0
EXPOSE 8080

# Daten (config, db) auf persistentes Volume
ENV OMNIROUTE_DATA_DIR=/data
VOLUME ["/data"]

CMD ["sh", "-c", "node bin/omniroute.js || node dist/index.js || npm start"]
