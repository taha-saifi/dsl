# DSL App — Local Orchestration

Runs the full stack (MongoDB, MinIO, backend, frontend) together via Docker Compose.

## Usage

```bash
# Start everything (builds backend/frontend images as needed)
docker compose up --build

# Stop everything (keeps data)
docker compose down

# Stop everything and wipe Mongo/MinIO data volumes for a clean slate
docker compose down -v
```

Once running:

- Frontend: http://localhost:5173
- Backend API: http://localhost:5000/api
- MinIO console: http://localhost:9001
- MongoDB: mongodb://localhost:27017 (no auth, local-dev only)



e2e-teacher@example.com
TestPass123!
admin@example.com
AdminPass123!