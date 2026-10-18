FROM node:22.23.3-alpine3.24 AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM node:22.23.3-alpine3.24 AS runner

ENV NODE_ENV=production

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force

COPY --from=builder --chown=node:node /app/dist ./dist

# The official node image ships an unprivileged "node" user.
USER node

# Default PORT; override at runtime via -e PORT=<value>
EXPOSE 5000

HEALTHCHECK --interval=15s --timeout=5s --start-period=30s --retries=3 \
  CMD wget -qO- "http://127.0.0.1:${PORT:-5000}/api/health" > /dev/null || exit 1

CMD ["node", "dist/server.js"]
