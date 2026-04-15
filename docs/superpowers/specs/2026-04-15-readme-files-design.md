# README Files Design Spec

## Context

Taskie is a gamified task management platform (Flutter + NestJS + static web) in a monorepo. Five README files need to be created/updated to showcase the project as a portfolio piece for potential employers. Written in third person, professional tone, with visual badges, architectural rationale, and design decision sections.

## Target Audience

Potential employers and recruiters browsing GitHub. Emphasis on skills, architectural decisions, and breadth of expertise.

## Structure: Hub and Spokes

Root README is the hub — project overview with links. Four sub-READMEs are self-contained deep dives.

---

## 1. Root README (`/README.md`)

### Header
- Project name + logo (`web/logo.png`)
- One-liner: "A gamified task management platform for teams"
- Shields.io badges row: License (MIT), API (NestJS), App (Flutter), Web (HTML/CSS/JS), CI/CD (GitHub Actions)

### Overview
- 3-4 sentences: what Taskie is (workspaces, tasks, goals, leaderboard, gamification)
- Full-stack monorepo covering backend, mobile, web, and CI/CD

### Architecture Overview
- Text-based diagram: Flutter App → Cloudflare → Nginx → NestJS API → PostgreSQL, plus Grafana Loki for logging, GHCR for Docker images, Google Play for distribution
- Brief infrastructure description: Hetzner VPS, Nginx reverse proxy, Cloudflare for DNS/security/SSL

### Project Structure
- Folder tree: api/, app/, web/, .github/
- One-liner per directory + link to its README

### Tech Stack Highlights
- Table with columns: Layer | Technology | Key Highlights
- Rows: Backend, Mobile, Web, Database, DevOps, CI/CD, Monitoring

### Key Technical Highlights
- Bullet list of cross-cutting concerns:
  - JWT auth with Access Token Versioning
  - Mobile log proxying through API to Grafana
  - Fully automated deployments with rollback capability
  - RBAC across backend and frontend
  - Offline caching with 3-layer fallback
  - Docker multi-stage builds with GHCR

### Cloudflare
- What Cloudflare provides: DNS management, SSL/TLS encryption, DDoS protection, WAF, caching, bot protection

---

## 2. API README (`/api/README.md`)

### Header
- Badges: NestJS, TypeScript, PostgreSQL, Docker, Swagger, Jest, Pino

### Overview
- RESTful API built with NestJS, TypeScript, PostgreSQL. Dockerized, deployed on Hetzner VPS behind Nginx. Serves Flutter app and handles mobile log proxying to Grafana.

### Tech Stack
- Table: Category | Technology
- Framework, Language, Database, ORM, Auth, Docs, Logging, Health, Scheduling, Validation, Config

### Architecture
- Layered: Controllers → Services → Repositories → Database
- Domain-driven: separate domain interfaces from persistence entities
- Folder tree of `src/modules/`
- Brief module descriptions: auth, workspace, task, goal, user, session, health, logger, logger-mobile, database, unit-of-work

### Security
- JWT dual-token system (15min access, 30-day refresh)
- Access Token Versioning (ATV) — force-invalidates tokens on permission changes
- Google OAuth integration
- RBAC with workspace roles (Manager, Member)
- Guards chain: JwtAuthGuard → WorkspaceMembershipGuard → WorkspaceRoleGuard
- Helmet security headers, CORS, body parser limits, trust proxy
- Global ValidationPipe (forbidNonWhitelisted, transform)
- Custom API error codes (18 defined)

### Database
- PostgreSQL with TypeORM
- 11 versioned migrations
- Soft deletes via DeleteDateColumn
- Database triggers for automated task assignment updates
- Seeding modules for development data
- Configurable connection pooling

### Logging & Monitoring
- Pino with dual transports (pino-pretty dev, pino-loki prod)
- Grafana Loki integration with batched shipping
- Mobile log proxying architecture: Flutter → API endpoint → Grafana Loki
- CLS-based async context logging (user ID throughout request lifecycle)
- Structured logging in exception filters

### API Documentation
- Swagger/OpenAPI at `{API_PREFIX}/docs`
- Bearer auth, mobile metadata headers documented
- Custom response wrapper in Swagger docs

### Error Handling
- 3-layer exception filter chain (Unknown → Base HTTP → API HTTP)
- Custom ApiHttpException with error codes
- Consistent `{ data, error }` response format
- Severity-based logging

### Notable Patterns
- Unit of Work for transaction management
- CLS for request-scoped context propagation
- Cron jobs (session cleanup, invite expiry)
- Health checks (DB, memory, disk)
- Global interceptors (response transformer, serializer, user context)
- API versioning (v1)

### Design Decisions
- Why NestJS (modular architecture, DI, decorator-based, enterprise patterns)
- Why TypeORM over Prisma/Knex (decorator-based entities align with NestJS, migration control)
- Why Pino over Winston (performance, structured JSON, native Loki transport)
- Why API as mobile log proxy (security — mobile clients shouldn't have Grafana credentials)
- Why ATV (immediate permission revocation without waiting for token expiry)
- Why Unit of Work (clean transaction boundaries across repositories)

---

## 3. Flutter App README (`/app/README.md`)

### Header
- Badges: Flutter, Dart, Provider, GoRouter, Hive, Firebase

### Overview
- Cross-platform mobile app with MVVM + Command pattern per official Flutter architecture guide. Provider for state management — demonstrating architecture > tooling.

### Tech Stack
- Table: Category | Technology
- Framework, Language, State Management, Routing, HTTP Client, Local Storage, Secure Storage, Auth, Logging, Firebase, UI, Localization

### Architecture
- MVVM + Command: View → ViewModel → Commands → Use Cases/Repositories → Results
- Command pattern: Command0, Command1, sealed Result<T>, debouncing, running/error/completed states
- Folder tree: domain/, data/, ui/, config/, routing/, logger/
- Layer responsibilities

### State Management
- Why Provider is sufficient with MVVM
- ChangeNotifier ViewModels scoped to screens
- Repository pattern with reactive propagation
- 8 use cases for multi-repository orchestration
- ProxyProvider2 for circular dependency resolution

### Navigation & Deep Linking
- GoRouter with StatefulShellRoute (persistent tabs: Tasks, Goals, Leaderboard)
- Global redirect for auth state
- Custom SharedAxisTransition animations
- Android App Links via `.well-known/assetlinks.json` (3 app variants: dev, production x2 signing configs)
- GoRouter deep link route handling (workspace join via invite token)

### Networking
- Dio with 5-interceptor chain: auth headers → client info → logging → 401 refresh → 403 handling
- Semaphore token refresh (queues requests via Completer)
- Separate Dio instance for mobile logging
- Typed ApiResponse<T> with 15+ error codes

### Offline Support & Caching
- 3-layer fallback: in-memory → Hive → API
- Hive for persisting user, workspaces, tasks, goals, leaderboard
- Auto-recovery on corrupted cache
- FlutterSecureStorage for tokens

### Logging
- LoggerHub delegate pattern (ConsoleLogger dev, RemoteLogger prod)
- Remote logs sent to API → Grafana Loki
- Smart filtering (excludes API exceptions, timeouts, cancellations)
- Fire-and-forget (never blocks app)
- Device metadata on every log

### Security
- Frontend RBAC service mirroring backend roles
- Encrypted token storage (Keychain/Keystore)
- Envied for compile-time environment config
- ProGuard in release builds

### Localization
- English + Croatian via ARB files
- Type-safe translations via gen-l10n

### UI/UX
- Material 3, custom theme (purple primary, orange accent)
- 44+ custom reusable widgets, 36 feature modules
- Device Preview for foldable testing
- Toast notifications

### Design Decisions
- Why MVVM + Command over BLoC (cleaner separation, explicit action semantics, official recommendation)
- Why Provider over Riverpod/BLoC (architecture handles complexity, proving architecture > tooling)
- Why Hive over SQLite (NoSQL fits caching, no schema management needed)
- Why separate Dio for logging (avoids circular dependency)
- Why GoRouter + StatefulShellRoute (tab persistence, deep link support)
- Why delegate pattern for logging (runtime switching without changing consumers)

---

## 4. Web README (`/web/README.md`)

### Header
- Badges: HTML5, CSS3, JavaScript, PWA

### Overview
- Static landing page, zero external dependencies, public-facing website with app download CTA, feature showcase, legal pages.

### Tech Stack
- HTML5, CSS3, vanilla JavaScript

### Features
- Hero with gradient text and animated app icon
- 4 feature cards with scroll-triggered animations (Intersection Observer)
- Responsive CSS Grid auto-fit
- Privacy Policy and Terms & Conditions
- Google Play CTA

### Design
- CSS Custom Properties for theming
- Mobile-first, 768px breakpoint
- CSS Grid `repeat(auto-fit, minmax(250px, 1fr))`
- Flexbox, BEM-like naming

### Animations & Interactivity
- fadeIn (hero load), fadeInUp (cards on scroll via Intersection Observer at 10% threshold)
- Hover: button lift + shadow, card lift + border color
- Hardware-accelerated (transforms, opacity)

### PWA & Cross-Platform
- Web App Manifest for installability
- Multi-resolution favicons (16px–512px)
- Android App Links via `.well-known/assetlinks.json` (3 app variants)

### Performance
- Zero dependencies, no CDN requests
- Embedded CSS/JS, single HTML per page
- HTML minification in deployment pipeline
- Intersection Observer (no scroll listeners)

### Design Decisions
- Why vanilla over framework (no need for React/Vue, zero deps = instant load, no maintenance)
- Why embedded styles (one fewer HTTP request, single-response render)
- Why Intersection Observer (performant native API, no jank)

---

## 5. CI/CD README (`/.github/README.md`)

### Header
- Badges: GitHub Actions, Docker, Fastlane, GHCR

### Overview
- Fully automated CI/CD for all 3 components. Code quality enforcement, testing, containerized deployments, Google Play releases, rollback capabilities.

### Workflows Overview
- Table: all 7 workflows (api-ci, api-deploy, api-rollback, app-ci, app-deploy, web-deploy, pr-lint) with trigger and purpose

### Code Quality & PR Validation
- Conventional Commits via pr-lint
- "Develop to main" strict title for releases
- Squash merge strategy
- Husky pre-commit (lint-staged: ESLint + Prettier) and pre-push (tests)

### API CI Pipeline
- Path-filtered triggers
- Steps: lint → test → build
- Cancel-in-progress concurrency

### API Deployment Pipeline
- Manual dispatch with "deployment" confirmation
- Branch restriction (main only)
- Docker Buildx with GHA layer caching
- GHCR push: `latest` + `sha-<commit>` tags
- SSH deploy: pull → stop → start with --restart always, --network host
- Migrations on startup (fail-fast)
- GitHub Release creation

### API Rollback Pipeline
- Manual dispatch with "rollback" confirmation + SHA tag
- Rejects "latest", validates image exists before stopping
- Database migration caveat

### Flutter App CI Pipeline
- Path-filtered triggers
- Java 17 + Flutter 3.32.0 (cached)
- Steps: codegen → analyze → format → test → debug APK build

### Flutter App Deployment Pipeline
- Manual dispatch with track selection (Internal/Production)
- Non-cancellable concurrency
- Build number: `RUN_NUMBER * 100 + RUN_ATTEMPT`
- Keystore from base64, App Bundle release build
- Fastlane → Google Play (dynamic track)
- GitHub Release for production

### Web Deployment Pipeline
- Manual dispatch, main branch only
- HTML minification (html-minifier-terser)
- SCP to VPS, SSH permission setup (www-data, 755)

### Infrastructure
- Hetzner VPS (API + Web via Nginx), GHCR (Docker images), Google Play (Flutter)
- Docker on host network

### Caching Strategies
- npm, Docker layers (Buildx GHA), Flutter SDK, Ruby/Bundler gems

### Safety Mechanisms
- Confirmation prompts, branch restrictions, tag validation, pre-stop verification, concurrency controls

### Design Decisions
- Why manual dispatch (controlled releases, confirmation gates)
- Why GHCR over Docker Hub (native GitHub integration, free, same auth)
- Why SHA tagging (precise rollback to any deployment)
- Why Fastlane (industry standard, signing/uploading/track management)
- Why `RUN_NUMBER * 100 + RUN_ATTEMPT` (unique numbers on retries, prevents Play Store rejection)
- Why HTML minification in pipeline (no build step for vanilla HTML, simple dev + optimized prod)
