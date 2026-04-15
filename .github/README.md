# Taskie CI/CD

<p>
  <img src="https://img.shields.io/badge/GitHub%20Actions-2088FF?logo=githubactions&logoColor=white" alt="GitHub Actions" />
  <img src="https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white" alt="Docker" />
  <img src="https://img.shields.io/badge/Fastlane-00F200?logo=fastlane&logoColor=white" alt="Fastlane" />
  <img src="https://img.shields.io/badge/GHCR-181717?logo=github&logoColor=white" alt="GHCR" />
</p>

## Overview

Fully automated CI/CD pipelines for all three components of the Taskie platform — API, Flutter mobile app, and web landing page. The setup covers code quality enforcement, automated testing, containerized deployments with rollback capability, and Google Play releases via Fastlane. All deployments are triggered manually with safety confirmation gates.

## Workflows Overview

| Workflow | File | Trigger | Purpose |
|----------|------|---------|---------|
| **API CI** | `api-ci.yml` | PR / push (path-filtered) | Lint, test, build |
| **API Deploy** | `api-deploy.yml` | Manual dispatch | Docker build → GHCR → SSH deploy to VPS |
| **API Rollback** | `api-rolback.yml` | Manual dispatch | Roll back to a previous Docker image by SHA tag |
| **App CI** | `app-ci.yml` | PR / push (path-filtered) | Analyze, format, test, build |
| **App Deploy** | `app-deploy.yml` | Manual dispatch | Build AAB → Fastlane → Google Play |
| **Web Deploy** | `web-deploy.yml` | Manual dispatch | Minify HTML → SCP → Nginx |
| **PR Lint** | `pr-lint.yml` | PR events | Conventional Commits / release title validation |

## Code Quality & PR Validation

### PR Title Validation

- **Feature branches → develop**: enforces [Conventional Commits](https://www.conventionalcommits.org/) format (feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert)
- **Develop → main**: requires exact title "Develop to main" for release merges
- **Squash merge strategy** — PR title becomes the commit message, so title validation replaces individual commit linting

### Local Git Hooks (Husky)

| Hook | Action |
|------|--------|
| **Pre-commit** | `lint-staged` — runs ESLint `--fix` and Prettier `--write` on staged `.ts` files |
| **Pre-push** | Runs `npm run test` — blocks push if unit tests fail |

## API CI Pipeline

Runs on PRs and pushes to main when `api/` files change.

```
Checkout → Setup Node.js 20 (npm cached) → npm ci → Lint Check → Unit Tests → Build
```

- **Path filtering** — only triggers when `api/**` or the workflow file changes
- **Concurrency** — cancel-in-progress on new pushes to the same branch

## API Deployment Pipeline

Manual dispatch with safety confirmation.

```
Confirm ("deployment") → Branch Check (main only) → Checkout
  → Login to GHCR → Setup Docker Buildx
  → Build & Push Image (latest + sha-<commit> tags)
  → SSH Deploy (pull → stop old → start new → prune)
  → Create GitHub Release
```

### Docker Image Tagging

Every deployment pushes two tags to GitHub Container Registry:

- **`latest`** — always points to the newest production image
- **`sha-<commit>`** — immutable tag tied to the specific commit, enabling precise rollback

### Docker Security

- **Non-root execution** — the production image runs as `USER node`, not root, limiting the blast radius of container exploits
- **`exec` form CMD** — `CMD` uses exec form (`["node", "..."]`) so Node.js receives OS signals directly, enabling graceful shutdown without zombie processes

### SSH Deployment

The workflow SSHs into the Hetzner VPS and:

1. Pulls the new Docker image from GHCR
2. Stops and removes the current container
3. Starts the new container with `--restart always`, `--network host` (host networking because PostgreSQL runs on localhost; Nginx handles external routing and UFW blocks direct access to the API port), and `--env-file .env`
4. Updates the `.env` file from GitHub Secrets (using `printf` to avoid `$` symbol interpretation)
5. Prunes dangling images

Database migrations run automatically on container startup — if the migration fails, the container exits immediately (fail-fast).

### Docker Build Caching

Docker Buildx uses **GitHub Actions cache** (`cache-from: type=gha`, `cache-to: type=gha,mode=max`) for layer caching between workflow runs, significantly reducing build times for unchanged layers.

## API Rollback Pipeline

Manual dispatch with safety confirmation and SHA tag input.

```
Confirm ("rollback") → Branch Check (main only) → Tag Validation (rejects "latest")
  → SSH: Verify Image Exists → Stop Current Container → Start Previous Version → Prune
```

**Safety checks:**
- Must type "rollback" to confirm
- Cannot roll back to the `latest` tag (must use a specific `sha-<commit>`)
- Verifies the target image exists in GHCR before stopping the current container

**Database caveat:** schema migrations are not automatically reversed. If the previous API version is incompatible with the current database schema, `npm run db:migration:revert` must be run manually inside the container.

## Flutter App CI Pipeline

Runs on PRs and pushes to main when `app/` files change.

```
Checkout → Setup Java 17 + Flutter 3.32.0 (cached)
  → Create google-services.json (from secret)
  → flutter pub get --enforce-lockfile → Build Runner (codegen with .env.test) → gen-l10n (localization)
  → flutter analyze (--fatal-infos --fatal-warnings)
  → dart format (--set-exit-if-changed)
  → flutter test
  → flutter build apk --debug --flavor production (dry run)
```

- **`--enforce-lockfile`** — fails if `pubspec.lock` doesn't match `pubspec.yaml`, ensuring reproducible builds
- **`.env.test`** — code generation uses a test environment file to avoid leaking real credentials in CI

## Flutter App Deployment Pipeline

Manual dispatch with track selection (Internal / Production).

```
Confirm ("deployment") → Branch Check (main only)
  → Setup Java 17 + Flutter 3.32.0 (cached)
  → Create .env + google-services.json
  → Codegen + Localization
  → Decode Android Keystore (from base64 secret)
  → Compute Build Number → Build App Bundle (.aab)
  → Setup Ruby 3.3 + Fastlane
  → Upload to Google Play (dynamic track)
  → Create GitHub Release (production only)
```

### Build Number Strategy

```
BUILD_NUMBER = GITHUB_RUN_NUMBER * 100 + GITHUB_RUN_ATTEMPT
```

This formula guarantees globally unique build numbers even on workflow retries (`RUN_ATTEMPT` increments on re-run). Google Play requires strictly increasing build numbers across all tracks — this approach prevents rejection from duplicate numbers.

### Concurrency

The app deploy workflow uses **non-cancellable concurrency** (`cancel-in-progress: false`). If two deployments run concurrently, the second waits instead of cancelling the first — this prevents orphaned builds on Google Play where a cancelled workflow could leave an incomplete upload.

### Fastlane Configuration

A single `deploy` lane in the `Fastfile` accepts a `track` option (internal or production). Upload skips metadata, images, and screenshots (`skip_upload_metadata: true`, `skip_upload_images: true`, `skip_upload_screenshots: true`) — these are managed manually via Google Play Console.

### Release Tagging

Both API and app deployments create GitHub Releases on production with auto-generated release notes:

- **API**: `api-v{version}` (version from `package.json`)
- **App**: `app-v{version}+{buildnumber}` (version from `pubspec.yaml` + computed build number)

## Web Deployment Pipeline

Manual dispatch, restricted to the main branch.

```
Branch Check (main only) → Checkout → Setup Node.js 20
  → Minify HTML (html-minifier-terser: collapse whitespace, remove comments, minify inline CSS/JS)
  → SCP to VPS (/tmp/taskie_web_temp)
  → SSH: Move to /var/www/taskieapp/public/ → Set www-data ownership → Set 755 permissions → Cleanup temp
```

## Infrastructure

```
┌─────────────────────────────────────────────────────┐
│                    Hetzner VPS                       │
│                                                      │
│  Nginx ──┬── /api/*  → Docker Container (NestJS)    │
│           └── /*     → /var/www/taskieapp/public/    │
│                                                      │
└─────────────────────────────────────────────────────┘

GitHub Container Registry (GHCR) ── Docker images (latest + sha-<commit>)

Google Play Store ── Flutter App Bundle (.aab) via Fastlane
```

- **API** runs as a Docker container on the host network, reverse-proxied by Nginx
- **Web** is served directly by Nginx from the filesystem
- **Flutter app** is distributed through Google Play (Internal and Production tracks)

## Caching Strategies

| What | How | Impact |
|------|-----|--------|
| **npm dependencies** | `actions/setup-node` with `cache: "npm"` | Skips `npm ci` download when lockfile unchanged |
| **Docker layers** | Buildx with `type=gha` cache | Reuses unchanged layers between deployments |
| **Flutter SDK** | `flutter-action` with `cache: true` | Skips SDK download on subsequent runs |
| **Ruby gems** | `setup-ruby` with `bundler-cache: true` | Caches Fastlane and dependencies |

## Safety Mechanisms

- **Deployment confirmation** — must type "deployment" or "rollback" to proceed (prevents accidental triggers)
- **Branch restrictions** — production deployments only from `main` branch
- **Image tag validation** — rollback workflow rejects the `latest` tag (must use specific SHA)
- **Pre-stop verification** — rollback validates the target image exists before stopping the current container
- **Concurrency controls** — CI workflows cancel-in-progress on new pushes; deploy workflows never cancel mid-run
- **GitHub Environments** — deployment jobs require environment approval

## Design Decisions

**Why manual dispatch over automatic deployment** — production deployments should be deliberate. Manual triggers with confirmation prompts prevent accidental releases, give the team control over deployment timing, and make rollback a conscious decision rather than an automated reaction.

**Why GHCR over Docker Hub** — GitHub Container Registry integrates natively with GitHub Actions (same authentication via `GITHUB_TOKEN`), is free for public repositories, and keeps the entire CI/CD pipeline within the GitHub ecosystem without managing separate Docker Hub credentials.

**Why SHA-based image tagging** — tagging every deployment with `sha-<commit>` creates an immutable history of every version that has been deployed. Rollback becomes a matter of specifying which SHA to revert to, with full traceability back to the exact commit.

**Why Fastlane for Google Play releases** — Fastlane is the industry standard for mobile app distribution. It handles APK/AAB signing, metadata management, track selection (internal/production), and upload — all configured declaratively in a `Fastfile`. The Ruby ecosystem is well-supported in CI environments.

**Why `RUN_NUMBER * 100 + RUN_ATTEMPT` for build numbers** — Google Play requires strictly increasing, globally unique build numbers across all tracks. Simple `RUN_NUMBER` would produce duplicates on workflow retries. Multiplying by 100 and adding the attempt number guarantees uniqueness while leaving room for retries (up to 99 per run).

**Why HTML minification in the pipeline rather than a build tool** — the web landing page is pure HTML with embedded CSS/JS — there is no build step. Adding a bundler for minification alone would be overkill. Instead, `html-minifier-terser` runs as a one-line step in the deployment pipeline, keeping development simple (edit HTML directly) while still optimizing for production.
