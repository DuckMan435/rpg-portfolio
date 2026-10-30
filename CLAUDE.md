# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

"Forge" is a small RPG character-creator portfolio project. A React SPA lets you create a character (pick a class and name), load a saved one, and click "Gain EXP" to level up. The backend is a FastAPI service over Postgres that uses **raw SQL via `sqlalchemy.text()`**. There is no ORM model layer and there are no migrations.

## Commands

Backend (repo root, Windows venv; the venv uses Python 3.14 while the Docker/Lambda runtime is 3.12):
```powershell
venv\Scripts\python.exe -m pip install -r requirements.txt
$env:DATABASE_URL = "postgresql://<user>:<pass>@localhost:5432/rpg_db"; $env:API_PREFIX = "/api"
venv\Scripts\python.exe -m uvicorn app.main:app --port 8001   # Swagger UI at /docs
```
- `.env` is loaded by `load_dotenv()`, but its `DATABASE_URL` host is `postgres_local` (the Docker container name). That only resolves inside the `forge-network` Docker network, so override the host to `localhost` when running on the host.
- Port 8000 is often taken by another local project on this machine. 8001 is used for this one.
- Set `API_PREFIX` from PowerShell, not Git Bash: MSYS rewrites `API_PREFIX=/api` into a Windows path and FastAPI then fails with "A path prefix must start with '/'".
- `uvicorn --reload` has been unreliable here (it detects changes but doesn't restart the worker). Restart manually.
- Containerized API: `docker build -t forge-api .` then `docker run --network forge-network --env-file .env -p 8000:8000 forge-api`. The image is cloud-neutral (no account-specific values), so it can run on any Kubernetes provider. `.dockerignore` keeps `.env*`, `keys/`, `k8s/`, `db/` and `terraform/` out of the image.
- Full local stack (API + a fresh Postgres seeded from `db/init`): `docker compose up --build`. The API is at `http://localhost:8001/api` and Postgres at `localhost:5433`. `docker compose down -v` wipes the database so it re-seeds on the next start. The compose password is a local-only default (`POSTGRES_PASSWORD`, overridable).

Database: the schema and game data (classes, stat types, base stats, level gains, settings) are in `db/init/01-schema.sql` and `db/init/02-seed.sql`, exported with `pg_dump`. Player characters aren't included. If you change the schema or game data, re-export both files. The older long-lived local Postgres is the Docker container `postgres_local` (db `rpg_db`, port 5432). Inspect it with `docker exec postgres_local psql -U postgres -d rpg_db -c "\d <table>"`.

Frontend (`frontend/`, Create React App + Tailwind 3):
```powershell
npm ci
$env:REACT_APP_API_BASE_URL = "http://localhost:8001/api"; npm start   # :3000; env var overrides .env.development
npm test -- --watchAll=false                      # all tests
npx react-scripts test src/App.test.js --watchAll=false -t "<test name>"   # single test
npm run build
```
`REACT_APP_API_BASE_URL` must include the `/api` prefix. The only test (`App.test.js`) is the unmodified CRA template ("learn react") and fails. There are no backend tests.

## Architecture

**Request flow:** `frontend/src/services/api.js` (all fetch calls) → `app/main.py` mounts `routers/characters.py` and `routers/classes.py` under `${API_PREFIX}/characters` and `${API_PREFIX}/classes` → SQL runs directly in the routers. `services/character_service.py` holds the game logic. `app/database.py` provides the `get_db` session dependency. The `models/` folder holds Pydantic request/response schemas only.

**Trailing slashes:** `FastAPI(redirect_slashes=False)` plus `StripTrailingSlashMiddleware` in `main.py`. Routes are declared **without** a trailing slash (collection routes use `@router.get("")`), and the middleware strips one from incoming paths. Redirects are avoided on purpose because they break behind API Gateway / the ALB. Keep new routes slash-less.

**Game rules (DB-driven):**
- Tables: `characters`, `classes`, `stat_types`, `class_basestats` (level-1 values), `class_level_gains` (per-level increments), `settings` (`xp_multiplier`, `max_level`).
- Stats are computed, not stored: `base + (level - 1) * gain` (`CharacterService.calculate_stats`).
- Leveling is cubic: going from level L to L+1 needs total XP ≥ `L³ × xp_multiplier`. `calculate_level` and `calculate_xp_to_next_level` must stay consistent with each other. `next_level_xp` in responses is the XP *remaining*, not a threshold. `max_level` is currently not enforced.
- DB constraints the API relies on: `character_name` is unique, max 30 chars, matches `^[a-zA-Z0-9 ]+$` (mirrored in `CharacterCreate`). The API maps violations to 409/422.
- Responses are wrapped as `{"message": ..., "data": ...}`. Exception: `GET /classes/{name}` returns the class object directly. Errors use `HTTPException` (`{"detail": ...}`).

**Frontend state:** there is no router. `App.js` switches on a `mode` string (`landing` / `wizard` / `select` / `sheet`) and holds the active `character`. `CharacterWizard` steps through `wizard/Step*.jsx`. Shared styles (`.panel`, `.btn-primary`) live in `src/index.css`.

## Workflow

Don't commit to `main` directly. Make each change in a git worktree on a new branch, push the branch, and open a PR against `main`. Before pushing, check the changed files for secrets and AWS account details (account ID, CloudFront distribution ID, database URLs).

## Kubernetes (cloud-neutral)

`k8s/` uses Kustomize. `k8s/base/` holds the Deployment, ClusterIP Service, ConfigMap (`API_PREFIX`) and an ingress-nginx Ingress for `/api`. The readiness probe calls `/api/classes`. `k8s/overlays/{local,aks,eks,gke}` only set the image: `local` uses the locally built `forge-api:latest` for Docker Desktop Kubernetes, and the cloud overlays have `<placeholder>` registry addresses to fill in. Keep account IDs, registry names and provider-specific annotations out of `base/`.
- Render without a cluster: `kubectl kustomize k8s/overlays/<name>`. Deploy: `kubectl apply -k k8s/overlays/<name>`.
- The Deployment reads `DATABASE_URL` from the Secret `forge-api-secret`. `k8s/secret.example.yaml` shows its shape; the real `k8s/secret.yaml` is gitignored. Or create it with `kubectl create secret generic forge-api-secret --from-literal=DATABASE_URL=...`.
- The cluster needs ingress-nginx installed, and a Postgres it can reach (a managed DB, seeded from `db/init`).
- Check `kubectl config current-context` before applying. It may still point at the old EKS cluster.

## Deployment (inactive)

The AWS deployment has been shut down, so nothing is deployed. The `Deploy` GitHub Actions workflow is disabled on GitHub (`gh workflow enable Deploy` turns it back on), and merging to `main` doesn't deploy. Don't run `terraform apply` or deploy scripts. The setup below is kept as a record of how the project deployed.

**Lambda (previously used by CI):** `.github/workflows/deploy.yml` runs on pushes to `main` that touch `app/**` or `frontend/**`. It builds `lambda.zip` with pip inside the Lambda Docker image (locally: `build.ps1`) and updates function `forge-lambda`. The frontend is synced to S3 and CloudFront is invalidated (locally: `deploy-frontend.ps1`). In `terraform/`: CloudFront serves S3 and routes `/api/*` → API Gateway HTTP API (`ANY /{proxy+}`) → Lambda (`app.main.handler`, via Mangum) in private subnets → RDS Postgres 15.
- The Lambda entry point is the module-level `handler = Mangum(app, lifespan="off")` in `app/main.py`. Keep it defined unconditionally, since `terraform/lambda.tf` sets no deployment-type env var.
- `deploy-frontend.ps1` has a `YOUR_DISTRIBUTION_ID` placeholder. The real CloudFront distribution ID is kept locally in the gitignored `.env.cloudfront`.

A move to EKS was started. Its AWS-specific parts (the original ALB-based `k8s/` manifests, `deploy-k8s.ps1`, EKS/ECR Terraform) were never committed and are archived outside the repo. The cloud-neutral `k8s/` above replaces those manifests. The local Terraform state still lists the EKS resources, so if AWS is ever brought back, restore the archived `.tf` files before running `terraform destroy`.

CORS origins (`localhost:3000` and the CloudFront domain) are hardcoded in `app/main.py`. Terraform state, `terraform.tfvars`, root `.env*` files and `keys/` hold real credentials and are gitignored. Don't print or commit them.
