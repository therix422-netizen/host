# OmniRoute = Next.js App → braucht build + next start
FROM node:20-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates python3 build-essential \
    && rm -rf /var/lib/apt/lists/*

# Repo klonen
RUN git clone --depth 1 https://github.com/diegosouzapw/OmniRoute.git .

# Dependencies + Next.js Production Build
RUN npm install --legacy-peer-deps
RUN npm run build

# ---------- Runtime ----------
FROM node:20-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Komplett vom Builder übernehmen (inkl. .next, node_modules, scripts)
COPY --from=builder /app /app

ENV NODE_ENV=production
ENV PORT=8080
ENV HOSTNAME=0.0.0.0
ENV OMNIROUTE_DATA_DIR=/data

VOLUME ["/data"]
EXPOSE 8080

# Next.js custom server starten
CMD ["npm", "start"]
