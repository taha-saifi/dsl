FROM node:22.23.3-alpine3.24 AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

# Vite bakes VITE_* variables into the built JS at build time, not at
# container runtime — this must be set before `npm run build` runs, or
# the bundle will end up with an empty/undefined API URL baked in.
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL

RUN npm run build

# Runs nginx as the unprivileged "nginx" user, listening on 8080.
FROM nginxinc/nginx-unprivileged:1.30.6-alpine AS runner

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/ > /dev/null || exit 1
