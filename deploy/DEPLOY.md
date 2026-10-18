# Deploying DSL (backend + teacher dashboard)

Production runs `docker-compose.prod.yml` from the **`deploy` branch** as a
Portainer stack, behind the server's existing Traefik. Only `dsl-backend/` and
`dsl-teacher-dashboard/` are built. `dsl-mobile/` and `docs/` are cloned with
the branch but never built or run.

| Host | Serves |
|---|---|
| `https://dsl.ssuniverse.dev` | teacher dashboard |
| `https://dsl-api.ssuniverse.dev/api` | REST API (also the future mobile app's `API_BASE_URL`) |
| `https://dsl-media.ssuniverse.dev/dsl-media/<key>` | uploaded media, read-only |

## What the stack contains

| Service | Purpose | Networks |
|---|---|---|
| `dsl-mongo` | MongoDB 7.0, auth on, data in `${DSL_DATA_DIR}/mongo` | internal |
| `dsl-mongo-init` | one-shot: creates or updates the app user (`readWrite` on `dsl` only) | internal |
| `dsl-minio` | S3 store (`pgsty/minio`, a rebuild of MinIO; the official images are no longer published), data in `${DSL_DATA_DIR}/minio` | internal, traefik |
| `dsl-minio-init` | one-shot: bucket, anonymous download, bucket-scoped backend user | internal |
| `dsl-backend` | Express API on :5000 | internal, traefik |
| `dsl-frontend` | dashboard, nginx (non-root) on :8080 | traefik |
| `dsl-backup-mongo` | `mongodump` at start and every 24 h, keeps 14 days | internal |
| `dsl-backup-media` | `mc mirror` of the bucket at start and every 24 h | internal |

- **No ports are published.** Traefik reaches the containers on the `traefik` network.
- **`internal` has no internet egress.** That covers Mongo, MinIO and their jobs.

## Assumptions about the server's Traefik

- **Entrypoints:** `http` and `https`.
- **Docker provider:** watches the external network **`traefik`**, with `exposedByDefault=false`. Every non-public service also sets `traefik.enable=false`.
- **Certificate:** the `*.ssuniverse.dev` wildcard is in Traefik's certificate store. Routers only set `tls=true`; they don't name a resolver.
  - If your wildcard is only issued through a resolver on one router, add `traefik.http.routers.<name>.tls.certresolver=<resolver>` to each `dsl-*` router.
- **HTTP to HTTPS:** the `http` entrypoint already redirects to `https`. The stack has no `http` routers.
- **Client IPs:** Traefik sees real client IPs, needed by the rate limits. If something like a Cloudflare Tunnel or proxy sits in front, configure Traefik's `forwardedHeaders.trustedIPs`. Otherwise every user shares one login rate limit.

---

## First-time setup

### 1. On the server: data folders

```bash
sudo install -d -o 1000 -g 1000 -m 750 \
  /srv/dsl /srv/dsl/mongo /srv/dsl/minio /srv/dsl/backups /srv/dsl/backups/mongo /srv/dsl/backups/minio
docker network inspect traefik > /dev/null && echo "traefik network OK"
```

Use the same UID and GID as `DSL_UID` and `DSL_GID`. Mongo and MinIO run as that user, so the files stay readable and easy to copy.

### 2. Generate secrets (on the server, or locally)

```bash
for v in MONGO_ROOT_PASSWORD MONGO_APP_PASSWORD MINIO_ROOT_PASSWORD MINIO_SECRET_KEY; do
  echo "$v=$(openssl rand -hex 32)"; done
echo "JWT_SECRET=$(openssl rand -base64 48)"
```

- Store them in your password manager.
- Hex is deliberate: `MONGO_APP_PASSWORD` goes into the Mongo URI without escaping.

### 3. GitHub

- **Fine-grained personal access token**
  - Repository access: only `taha-saifi/dsl`.
  - Permissions: **Contents: Read-only**.
  - Set an expiry date, and note when to renew it.
- **Ruleset on `deploy`** (Settings → Rules → Rulesets): block force pushes and block deletion.

### 4. Portainer: create the stack

**Stacks → Add stack → Repository**

| Field | Value |
|---|---|
| Name | `dsl` |
| Repository URL | `https://github.com/taha-saifi/dsl` |
| Repository reference | `refs/heads/deploy` |
| Compose path | `docker-compose.prod.yml` |
| Authentication | on: your GitHub username + the PAT |
| GitOps updates | on: polling (5 min) or webhook; turn on **Force redeployment** so pushes rebuild the images |
| Environment variables | every variable in `deploy/.env.prod.example`, filled in (or "Load variables from .env file") |

Click **Deploy the stack**. The first deploy builds both images on the server, which takes a few minutes.

> If Portainer can't build (`build:` not supported in your Portainer version, or it's too slow), tell Claude. The fallback is a GitHub Action that pushes images to GHCR, with `image:` in place of `build:`.

### 5. Check the deploy

1. **Portainer → Stacks → dsl**:
   - `dsl-mongo-init` and `dsl-minio-init` show **Exited (0)**;
   - all other services are **running (healthy)**.
2. **Logs:**
   - `dsl-mongo-init` says `Created app user dsl_app`;
   - `dsl-minio-init` says `MinIO bucket and backend user are ready.`;
   - `dsl-backend` says `MongoDB connected` and `Server listening on port 5000.`
3. **From anywhere:**

   ```bash
   curl -s https://dsl-api.ssuniverse.dev/api/health          # {"data":{"status":"ok"}}
   curl -sI https://dsl.ssuniverse.dev | grep -iE 'strict-transport|content-security'
   curl -sI http://dsl.ssuniverse.dev | head -1               # redirect to https
   ```

4. **No new ports on the host:** `ss -tlnp` is unchanged.

### 6. First admin

Use Portainer → `dsl-backend` → **Console** (`/bin/sh`), or SSH:

```bash
docker exec -it dsl-dsl-backend-1 node dist/scripts/createAdmin.js \
  --email you@example.com --first-name Ada --last-name Admin --password 'choose-a-strong-one'
```

Prefix the command with a space so it stays out of shell history. Then log in at `https://dsl.ssuniverse.dev`, create a course, upload an image, and confirm it loads from `dsl-media.ssuniverse.dev`.

---

## Day to day

**Release.** Bring `main` into `deploy` and push:

```bash
git switch deploy && git merge main && git push
```

Portainer picks up the push (polling or webhook) and rebuilds. Only `deploy` is ever deployed.

**Rollback.** `git revert <bad-commit>` on `deploy`, then push. A rollback doesn't undo data changes; restore a backup for that (below).

**Changing a hostname.** Change it in the stack's environment variables and redeploy. The dashboard bakes `API_HOST` in at build time, so its image is rebuilt anyway. Hostnames are compiled into the mobile release build, so avoid changing `API_HOST` and `MEDIA_HOST`.

**Logs.** Portainer → container → Logs, or `docker logs -f dsl-dsl-backend-1`. They rotate at 10 MB × 3 per container.

## Backups and restore

- **Database:** `${DSL_DATA_DIR}/backups/mongo/dsl-<UTC time>.archive.gz`, written at every deploy and every 24 h, kept 14 days.
- **Media:** `${DSL_DATA_DIR}/backups/minio/dsl-media/` holds plain files, refreshed every 24 h.
- **Off the box:** copy `${DSL_DATA_DIR}/backups` to a NAS or off-site (restic or rsync cron on the host). Backups on the same disk don't survive a disk failure.

**Restore the database** into the running stack. This replaces existing documents.

```bash
docker exec -i dsl-dsl-mongo-1 mongorestore --drop --gzip --archive \
  --authenticationDatabase admin -u root -p "$MONGO_ROOT_PASSWORD" \
  < /srv/dsl/backups/mongo/dsl-YYYYmmdd-HHMMSS.archive.gz
```

In both commands, set `MONGO_ROOT_PASSWORD` and `MINIO_ROOT_PASSWORD` in your shell first (read them from your password manager). Start the line with a space so it stays out of shell history.

**Restore media** from the mirror into the running bucket (adds and overwrites, never deletes):

```bash
docker run --rm --network dsl_internal -e MC_CONFIG_DIR=/tmp/.mc \
  -v /srv/dsl/backups/minio:/backups:ro --entrypoint sh \
  pgsty/minio:RELEASE.2026-08-04T00-00-00Z -c \
  "mc alias set dsl http://dsl-minio:9000 dsl-minio-root '$MINIO_ROOT_PASSWORD' && \
   mc mirror --overwrite /backups/dsl-media dsl/dsl-media"
```

Test a restore once before relying on the backups.

## Migrating to another server

1. **Stop the stack** in Portainer.
2. **Copy the data:** `sudo rsync -aHAX /srv/dsl/ newhost:/srv/dsl/`.
3. **Create the stack again** on the new host: same Git settings, same environment variables.
4. **Point DNS** at the new host, if it changed.

The Mongo and MinIO data folders are bind mounts, so nothing lives inside Docker volumes.

## Rotating secrets

| Secret | How to rotate it |
|---|---|
| `MONGO_APP_PASSWORD` | change it in Portainer and redeploy. `dsl-mongo-init` updates the user before the backend starts |
| `MINIO_SECRET_KEY` | change it and redeploy. `dsl-minio-init` updates the user |
| `JWT_SECRET` | change it and redeploy. Every user is logged out |
| `MONGO_ROOT_PASSWORD` | **the env var only applies to an empty data folder.** Change it inside Mongo first, then in Portainer, then redeploy: `docker exec -it dsl-dsl-mongo-1 mongosh -u root -p --authenticationDatabase admin --eval 'db.getSiblingDB("admin").changeUserPassword("root", "<new>")'` |
| `MINIO_ROOT_PASSWORD` | change it in Portainer and redeploy |

## Local dry run (before touching the server)

Runs the production stack on your machine behind a throwaway Traefik that mirrors the server's: entrypoints `http` and `https`, network `traefik`.

```bash
docker compose -f deploy/dryrun/docker-compose.yml up -d   # local Traefik on :80/:443
mkdir -p .dryrun-data/{mongo,minio,backups/mongo,backups/minio}
# dryrun.env: copy .env.prod.example, set the *_HOST values to dsl.localhost,
# dsl-api.localhost and dsl-media.localhost, DSL_DATA_DIR=$PWD/.dryrun-data,
# fill the secrets. Keep it outside the repo.
docker compose -f docker-compose.prod.yml --env-file ~/dryrun.env up -d --build
```

- Open `https://dsl-api.localhost/api/health` and `https://dsl-media.localhost/` once, and accept the self-signed certificate. Otherwise the dashboard's requests to them fail.
- Then open `https://dsl.localhost`.
- **Tear down:**

  ```bash
  docker compose -f docker-compose.prod.yml --env-file ~/dryrun.env down
  docker compose -f deploy/dryrun/docker-compose.yml down
  ```

  Data stays in `.dryrun-data/`, which is gitignored; delete it to start fresh.
