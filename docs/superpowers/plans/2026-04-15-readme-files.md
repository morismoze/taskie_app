# README Files Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create/update 5 README files (root, api, app, web, .github) as portfolio-quality documentation showcasing architectural decisions and technical skills.

**Architecture:** Hub-and-spokes model — root README summarizes and links to 4 self-contained sub-READMEs. Each sub-README follows the same template: badges, overview, tech stack, architecture, features, design decisions.

**Tech Stack:** Markdown, shields.io badges

**Important:** No co-authored-by lines in any commits. User is the sole author.

---

### Task 1: Write Root README

**Files:**
- Rewrite: `/README.md`

- [ ] **Step 1: Write the root README**

Write `/README.md` with the following complete content:

```markdown
<p align="center">
  <img src="web/logo.png" alt="Taskie Logo" width="80" height="80" style="border-radius: 16px;" />
</p>

<h1 align="center">Taskie</h1>

<p align="center">A gamified task management platform for teams</p>

<p align="center">
  <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License" />
  <img src="https://img.shields.io/badge/API-NestJS-E0234E?logo=nestjs" alt="API" />
  <img src="https://img.shields.io/badge/App-Flutter-02569B?logo=flutter" alt="App" />
  <img src="https://img.shields.io/badge/Web-HTML%2FCSS%2FJS-F7DF1E?logo=javascript" alt="Web" />
  <img src="https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=githubactions" alt="CI/CD" />
</p>

---

## Overview

Taskie is a full-stack gamified task management platform where teams organize into workspaces, create tasks and goals, earn reward points for completed work, and compete on leaderboards. The project is structured as a monorepo covering a NestJS backend API, a Flutter mobile application, a static landing page, and fully automated CI/CD pipelines.

## Architecture Overview

```
                        ┌──────────────┐
                        │ Google Play  │
                        │   Store      │
                        └──────┬───────┘
                               │ distributes
                               ▼
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│ Flutter App  │──────▶│  Cloudflare  │──────▶│    Nginx     │
│  (Mobile)    │       │  DNS / SSL   │       │   Reverse    │
└──────────────┘       │  DDoS / WAF  │       │    Proxy     │
                       └──────────────┘       └──────┬───────┘
                                                     │
                                              ┌──────▼───────┐
                                              │  NestJS API  │
                                              │  (Docker)    │
                                              └──────┬───────┘
                                                     │
                                    ┌────────────────┼────────────────┐
                                    │                │                │
                             ┌──────▼───────┐ ┌──────▼───────┐ ┌─────▼────────┐
                             │ PostgreSQL   │ │ Grafana Loki │ │    GHCR      │
                             │  Database    │ │  (Logging)   │ │ (Docker Hub) │
                             └──────────────┘ └──────────────┘ └──────────────┘
```

The API and web landing page are hosted on a **Hetzner VPS** behind an **Nginx** reverse proxy, with **Cloudflare** providing DNS management, SSL/TLS termination, DDoS protection, Web Application Firewall (WAF), caching, and bot mitigation. The Flutter mobile app communicates with the API through Cloudflare, and mobile logs are proxied through the API to **Grafana Loki** for centralized monitoring. Docker images are stored in **GitHub Container Registry (GHCR)**.

## Project Structure

```
taskie_app/
├── api/          # NestJS backend API (TypeScript)
├── app/          # Flutter mobile application (Dart)
├── web/          # Static landing page (HTML/CSS/JS)
└── .github/      # CI/CD workflows (GitHub Actions)
```

| Directory | Description | README |
|-----------|-------------|--------|
| [`api/`](api/) | RESTful API with JWT auth, PostgreSQL, Docker, Swagger | [API README](api/README.md) |
| [`app/`](app/) | Cross-platform mobile app with MVVM + Command architecture | [App README](app/README.md) |
| [`web/`](web/) | Zero-dependency landing page with PWA support | [Web README](web/README.md) |
| [`.github/`](.github/) | Automated CI/CD pipelines with rollback capabilities | [CI/CD README](.github/README.md) |

## Tech Stack Highlights

| Layer | Technology | Key Highlights |
|-------|-----------|----------------|
| **Backend** | NestJS, TypeScript | Modular architecture, DI, guards, interceptors, decorators |
| **Mobile** | Flutter, Dart | MVVM + Command pattern, Provider, GoRouter |
| **Web** | HTML5, CSS3, JS | Zero dependencies, CSS Grid, Intersection Observer |
| **Database** | PostgreSQL, TypeORM | 11 versioned migrations, soft deletes, triggers |
| **DevOps** | Docker, Nginx, Hetzner | Multi-stage builds, reverse proxy, VPS deployment |
| **CI/CD** | GitHub Actions, Fastlane | Automated deploys, rollback, Google Play releases |
| **Monitoring** | Pino, Grafana Loki | Dual-transport logging, mobile log proxying |

## Key Technical Highlights

- **JWT Authentication with Access Token Versioning (ATV)** — immediate permission revocation without waiting for token expiry
- **Mobile Log Proxying** — Flutter logs route through the API to Grafana Loki, keeping monitoring credentials server-side
- **Fully Automated Deployments** — API (Docker/SSH), Flutter (Fastlane/Google Play), and Web (SCP/SSH) with rollback capability
- **Role-Based Access Control (RBAC)** — enforced on both backend (guards) and frontend (RBAC service) for consistent authorization
- **Offline-First Caching** — 3-layer data fallback (in-memory → Hive → API) with automatic corruption recovery
- **Docker Multi-Stage Builds** — optimized production images pushed to GitHub Container Registry (GHCR) with SHA-based tagging for rollback history

## Cloudflare

Cloudflare sits in front of the infrastructure and provides:

- **DNS Management** — domain routing and nameserver configuration
- **SSL/TLS Encryption** — automatic certificate provisioning and HTTPS enforcement
- **DDoS Protection** — layer 3/4/7 attack mitigation
- **Web Application Firewall (WAF)** — rule-based request filtering
- **Caching** — static asset caching and bandwidth optimization
- **Bot Protection** — automated traffic detection and challenge mechanisms

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
```

- [ ] **Step 2: Verify the README renders correctly**

Run: `head -5 /Users/morismoze/Documents/taskie_app/README.md`
Expected: First 5 lines of the new README visible

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: Rewrite root README with project overview and architecture"
```

---

### Task 2: Write API README

**Files:**
- Create: `/api/README.md`

- [ ] **Step 1: Write the API README**

Write `/api/README.md` with the following complete content:

```markdown
# Taskie API

<p>
  <img src="https://img.shields.io/badge/NestJS-E0234E?logo=nestjs&logoColor=white" alt="NestJS" />
  <img src="https://img.shields.io/badge/TypeScript-3178C6?logo=typescript&logoColor=white" alt="TypeScript" />
  <img src="https://img.shields.io/badge/PostgreSQL-4169E1?logo=postgresql&logoColor=white" alt="PostgreSQL" />
  <img src="https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white" alt="Docker" />
  <img src="https://img.shields.io/badge/Swagger-85EA2D?logo=swagger&logoColor=black" alt="Swagger" />
  <img src="https://img.shields.io/badge/Jest-C21325?logo=jest&logoColor=white" alt="Jest" />
  <img src="https://img.shields.io/badge/Pino-687634?logo=pino&logoColor=white" alt="Pino" />
</p>

## Overview

The Taskie API is a RESTful backend built with **NestJS** and **TypeScript**, backed by **PostgreSQL** via **TypeORM**. It is fully dockerized, deployed on a **Hetzner VPS** behind **Nginx**, and serves as the backbone for the Flutter mobile application. Beyond standard CRUD operations, the API handles JWT authentication with token versioning, role-based access control, mobile log proxying to Grafana, and automated session/invite lifecycle management via cron jobs.

## Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | NestJS 10 |
| **Language** | TypeScript 5.1 (strict mode) |
| **Database** | PostgreSQL 16.2 |
| **ORM** | TypeORM 0.3 |
| **Authentication** | Passport.js + JWT, Google OAuth |
| **API Docs** | Swagger / OpenAPI 3.0 (`@nestjs/swagger`) |
| **Logging** | Pino + pino-loki (Grafana Loki) |
| **Health Checks** | `@nestjs/terminus` (DB, memory, disk) |
| **Scheduling** | `@nestjs/schedule` (cron jobs) |
| **Validation** | `class-validator` + `class-transformer` |
| **Config** | `@nestjs/config` with typed, validated env |
| **Context** | `nestjs-cls` (Continuation Local Storage) |
| **Container** | Docker (multi-stage build, Alpine) |
| **Runtime** | Node.js 20 |

## Architecture

The API follows a **layered architecture** with domain-driven design principles, separating concerns across well-defined boundaries:

```
Request → Guards → Controller → Service → Repository → Database
                                   ↕
                              Domain Models
```

**Layers:**

- **Controllers** — handle HTTP requests, validate input via DTOs, delegate to services
- **Services** — contain business logic, orchestrate repositories, manage transactions via Unit of Work
- **Repositories** — abstract database access, handle TypeORM queries
- **Domain** — pure interfaces and enums, independent of persistence

### Module Structure

```
src/
├── common/              # Shared decorators, guards, interceptors, helpers
├── config/              # App-wide configuration
├── database/            # Migrations, seeds, data source config
├── exception/           # Custom exceptions, filters, error codes
└── modules/
    ├── auth/
    │   ├── core/        # JWT strategy, token management, password hashing
    │   └── auth-google/ # Google OAuth integration
    ├── workspace/
    │   ├── workspace-module/       # Workspace CRUD
    │   ├── workspace-user-module/  # Membership management
    │   └── workspace-invite/       # Invite tokens with expiry
    ├── task/
    │   ├── task-module/            # Task CRUD with reward points
    │   └── task-assignment-module/ # Task-user assignments
    ├── goal/            # Goal tracking with required points
    ├── user/            # User management
    ├── session/         # Session tracking with cleanup cron
    ├── health/          # Liveness probes (DB, memory, disk)
    ├── logger/          # Pino logger adapter
    ├── logger-mobile/   # Mobile log ingestion endpoint
    ├── database/        # TypeORM configuration module
    └── unit-of-work/    # Transaction management service
```

Each module follows a consistent internal structure:

```
module/
├── controllers/     # HTTP endpoints
├── services/        # Business logic
├── dto/
│   ├── request/     # Input validation DTOs
│   └── response/    # Output serialization DTOs
├── domain/          # Interfaces, enums
├── persistence/     # Entities, repositories
├── guards/          # Authorization guards
├── decorators/      # Custom decorators
└── cron/            # Scheduled tasks (where applicable)
```

## Security

### Authentication

The API implements a **dual-token JWT system**:

- **Access Token** — short-lived (15 minutes), used for API authorization
- **Refresh Token** — long-lived (30 days), used to obtain new access tokens

Both tokens are validated against a session record in the database on every request, ensuring revoked sessions are immediately rejected.

### Access Token Versioning (ATV)

A version integer on the session entity is incremented whenever a user's permissions change (e.g., role update, workspace removal). The JWT strategy compares the token's embedded version against the database — a mismatch forces the client to re-authenticate, providing **immediate permission revocation** without waiting for token expiry.

### Google OAuth

Integrated via `google-auth-library` for social sign-in. Token verification happens server-side, and the user is created or matched to an existing account.

### Role-Based Access Control (RBAC)

Two workspace-level roles: **Manager** and **Member**. Enforced via a guard chain:

```
JwtAuthGuard → WorkspaceMembershipGuard → WorkspaceRoleGuard
```

The `@RequireWorkspaceUserRole()` decorator specifies the minimum role required for each endpoint.

### Input Validation & Hardening

- **Global ValidationPipe** with `forbidNonWhitelisted: true` — rejects unknown request properties
- **Helmet** for security headers (CSP, HSTS, X-Frame-Options, X-Content-Type-Options)
- **CORS** with configurable origins
- **Body parser** limited to 10MB
- **Trust proxy** configured for reverse proxy setups (correct client IP from `X-Forwarded-For`)
- **Custom validators**: future date validation, numeric step validation, workspace name rules

## Database

**PostgreSQL 16.2** with **TypeORM**, managed through:

- **11 versioned migrations** — schema changes tracked in source control, applied automatically on container startup
- **Soft deletes** — `@DeleteDateColumn()` on all entities for data recovery capability
- **Database triggers** — automated task assignment status updates when parent task state changes
- **Seeding modules** — structured seed data for development (users, workspaces, tasks, goals)
- **Connection pooling** — configurable pool size (default: 10 connections)
- **Base entity** — shared `id` (UUID), `createdAt`, `updatedAt`, `deletedAt` across all entities

## Logging & Monitoring

### Pino Logger

Pino was chosen for its high performance and structured JSON output. The logger uses **dual transports**:

- **Development**: `pino-pretty` for human-readable console output at `debug` level
- **Production**: `pino-loki` for batched log shipping to **Grafana Loki** at `warn` level, with labels `{ app: "taskie-api", env: "production" }`

### Mobile Log Proxying

The API acts as a **log proxy** for the Flutter mobile app:

```
Flutter App → POST /api/v1/mobile-logs → API → Grafana Loki
```

Mobile clients send log events (with level, message, stack trace, device metadata) to a dedicated API endpoint. The API forwards these to Grafana Loki. This architecture ensures **mobile clients never hold Grafana credentials** — all monitoring access is server-side.

### Async Context Logging

Using **nestjs-cls** (Continuation Local Storage), the authenticated user's ID is injected into the request context via `UserContextInterceptor`. This makes the user ID available in every log entry throughout the request lifecycle without manual parameter passing.

### Structured Exception Logging

Exception filters log with full request context: HTTP method, URL, client IP, user-agent, error code, and stack trace (for server errors). Business logic errors (4xx) are logged at `warn` level; server errors (5xx) at `error` level.

## API Documentation

**Swagger / OpenAPI 3.0** is hosted alongside the API at the `{API_PREFIX}/docs` route (e.g., `/api/docs`).

- **Bearer authentication** configured globally
- **Mobile app metadata headers** documented (`x-device-model`, `x-os-version`, `x-app-version`, `x-build-number`)
- **Response wrapper** — a custom utility auto-updates Swagger docs to reflect the actual response format: `{ data: T, error: null }` for success, `{ error: ApiError, data: null }` for errors

## Error Handling

A **3-layer exception filter chain** processes all errors:

1. **UnknownExceptionsFilter** — catches unexpected runtime errors, logs with stack trace, returns 500
2. **BaseHttpExceptionsFilter** — catches standard NestJS `HttpException` (validation, auth errors)
3. **ApiHttpExceptionsFilter** — catches custom `ApiHttpException` with business-specific error codes

**18 custom error codes** (e.g., `TASK_CLOSED`, `WORKSPACE_INVITE_EXPIRED`, `SOLE_MANAGER_CONFLICT`) enable the mobile client to display localized, context-aware error messages. All responses follow a consistent format:

```json
// Success (2xx)
{ "data": { ... }, "error": null }

// Error (4xx/5xx)
{ "data": null, "error": { "code": "7", "message": "..." } }
```

## Notable Patterns

- **Unit of Work** — request-scoped service wrapping multi-repository operations in a single database transaction with automatic rollback on failure
- **CLS Context Propagation** — user identity available in any service without explicit parameter passing
- **Cron Jobs** — weekly cleanup of expired sessions (30-day TTL) and used/expired workspace invite tokens
- **Health Checks** — liveness endpoint checking database connectivity (1.5s timeout), heap memory (<150MB), RSS memory (<300MB), and disk usage (<80%)
- **Global Interceptors** — response transformation (wrapping), class serialization (DTO filtering), and user context injection
- **API Versioning** — all endpoints versioned under `/api/v1/`

## Design Decisions

**Why NestJS** — its modular architecture, built-in dependency injection, and decorator-based approach provide enterprise-grade structure. The opinionated framework enforces consistency across a growing codebase, and the module system maps naturally to domain boundaries.

**Why TypeORM over Prisma or Knex** — TypeORM's decorator-based entity definitions align with the NestJS decorator philosophy, keeping the codebase stylistically consistent. It also provides fine-grained migration control and supports advanced features like database triggers and soft deletes natively.

**Why Pino over Winston** — Pino's architecture is built for performance (low-overhead structured logging), and its `pino-loki` transport provides native Grafana Loki integration without a sidecar or additional infrastructure. Winston would require a custom transport or external log shipper.

**Why the API acts as a mobile log proxy** — exposing Grafana Loki credentials to mobile clients would be a security risk. By routing mobile logs through the API, monitoring credentials remain server-side, and the API can filter, validate, and enrich log data before forwarding.

**Why Access Token Versioning** — standard JWT expiry means a removed user retains access until the token expires (up to 15 minutes). ATV provides immediate revocation by incrementing a version counter on permission changes — the next API call with a stale version returns 401.

**Why Unit of Work** — operations that span multiple repositories (e.g., creating a workspace with an initial member and invite) need atomic transactions. The Unit of Work pattern provides clean transaction boundaries without leaking transaction management into service logic.
```

- [ ] **Step 2: Verify the file was created**

Run: `head -5 /Users/morismoze/Documents/taskie_app/api/README.md`
Expected: First 5 lines visible

- [ ] **Step 3: Commit**

```bash
git add api/README.md
git commit -m "docs: Add API README with architecture, security, and design decisions"
```

---

### Task 3: Write Flutter App README

**Files:**
- Rewrite: `/app/README.md`

- [ ] **Step 1: Write the Flutter app README**

Write `/app/README.md` with the following complete content:

```markdown
# Taskie Mobile App

<p>
  <img src="https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Provider-02569B?logo=flutter&logoColor=white" alt="Provider" />
  <img src="https://img.shields.io/badge/GoRouter-02569B?logo=flutter&logoColor=white" alt="GoRouter" />
  <img src="https://img.shields.io/badge/Hive-FFC107?logo=hive&logoColor=black" alt="Hive" />
  <img src="https://img.shields.io/badge/Firebase-DD2C00?logo=firebase&logoColor=white" alt="Firebase" />
</p>

## Overview

The Taskie mobile app is a cross-platform application built with **Flutter**, following the **MVVM architecture with the Command pattern** as recommended by the [official Flutter architecture guide](https://docs.flutter.dev/app-architecture/guide). It uses **Provider** for state management — demonstrating that a well-structured architecture eliminates the need for complex state management frameworks. The app communicates with the NestJS backend, supports offline caching, remote logging to Grafana, and is distributed via Google Play.

## Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter 3.8+ |
| **Language** | Dart |
| **State Management** | Provider 6.1 |
| **Routing** | GoRouter 15.1 (StatefulShellRoute) |
| **HTTP Client** | Dio 5.8 |
| **Local Cache** | Hive 2.2 (NoSQL) |
| **Secure Storage** | FlutterSecureStorage 9.2 |
| **Authentication** | Google Sign-In 6.3 |
| **Logging** | Custom logger → API → Grafana Loki |
| **Firebase** | Remote Config 6.1, Core 4.4 |
| **UI** | Material 3, custom theme |
| **Localization** | Flutter gen-l10n (English, Croatian) |
| **Build** | Envied, build_runner, json_serializable |

## Architecture

The app follows **MVVM (Model-View-ViewModel)** with the **Command pattern** for action handling, creating a clear unidirectional data flow:

```
View (observes) → ViewModel (exposes Commands) → Command (executes) → Use Case / Repository
                                                                              ↓
View (rebuilds) ← ViewModel (notifies) ← Command (updates result) ← Result<T> (Ok / Error)
```

### Command Pattern

The `Command` implementation (`lib/utils/command.dart`) provides:

- **`Command0<T>`** — parameterless async action
- **`Command1<T, A>`** — single-parameter async action
- **Sealed `Result<T>`** — type-safe `Ok<T>` / `Error<T>` responses
- **Built-in debouncing** — prevents duplicate executions while running
- **Observable state** — `.running`, `.error`, `.completed` properties for UI binding

ViewModels extend `ChangeNotifier` and expose `Command` objects. Views observe the ViewModel and react to command state changes — no manual state flags, no boilerplate.

### Layer Structure

```
lib/
├── config/
│   ├── dependencies.dart    # Provider setup (DI container)
│   ├── environment/         # Compile-time env config (Envied)
│   └── api_endpoints.dart   # API route constants
├── data/
│   ├── repositories/        # 8 domain repositories (ChangeNotifier)
│   └── services/
│       ├── api/             # Dio clients, interceptors, response models
│       ├── external/        # Firebase, Google Sign-In
│       └── local/           # Hive, SecureStorage, SharedPreferences, EventBus
├── domain/
│   ├── models/              # 17+ domain models (json_serializable)
│   ├── use_cases/           # 8 use cases (multi-repo orchestration)
│   └── constants/           # RBAC rules, validation, business rules
├── ui/
│   ├── core/
│   │   ├── theme/           # Colors, typography, dimensions
│   │   ├── ui/              # 44+ reusable custom widgets
│   │   ├── l10n/            # Localization (EN, HR)
│   │   └── services/        # RBAC service
│   └── [feature]/           # 36 feature modules
│       ├── view_models/     # ChangeNotifier ViewModels
│       └── widgets/         # Feature-specific UI
├── routing/                 # GoRouter config, route constants
├── logger/                  # Logger interface, hub, console, remote
└── utils/                   # Command pattern, LRU cache
```

**Each feature module** contains its own ViewModels and widgets, keeping UI concerns isolated. ViewModels receive repositories and use cases via constructor injection from the Provider tree.

## State Management

Provider is used with **ChangeNotifier** — and that's it. No BLoC, no Riverpod, no Redux. The architecture itself handles the complexity:

- **ViewModels** are `ChangeNotifier` instances scoped to their screen — state is local and predictable
- **Repositories** are `ChangeNotifier` providers that hold domain data and notify dependents when it changes
- **Use Cases** orchestrate multi-repository operations (8 total: sign-in, sign-out, token refresh, workspace switching, workspace creation, workspace joining, cache purging, invite sharing)
- **`ProxyProvider2`** resolves a circular dependency in the logging chain (`ClientInfoRepository → RemoteLogger → MobileLoggingApiClient → ClientInfoRepository`) using setter injection

The key insight: when the architecture enforces clean separation (View → ViewModel → Repository → Service), the state management layer only needs to provide reactivity and dependency injection — Provider does both.

## Navigation & Deep Linking

**GoRouter** with **StatefulShellRoute** provides tab-based navigation with persistent state across three main branches:

| Tab | Route | Feature |
|-----|-------|---------|
| Tasks | `/workspaces/:id/tasks` | Task management with creation, editing, assignments |
| Goals | `/workspaces/:id/goals` | Goal tracking with creation and editing |
| Leaderboard | `/workspaces/:id/leaderboard` | Point-based team rankings |

**Key navigation features:**

- **StatefulShellRoute with IndexedStack** — tab content persists when switching between tabs (no rebuild)
- **Global redirect** — auth state changes trigger navigation via `Listenable.merge` on the auth repository
- **Custom transitions** — `SharedAxisTransition` animations (250-400ms) for smooth screen changes
- **Deep linking** — Android App Links configured via `.well-known/assetlinks.json` for 3 app variants (dev, production with 2 signing configs), enabling direct navigation to workspace join routes from shared invite links
- **Query parameters** — `from`, `from_uid`, `next` parameters for post-auth redirect flow

## Networking

**Dio** HTTP client with a **5-interceptor chain**:

```
Request → RequestHeadersAuthInterceptor      (adds Bearer token)
        → RequestHeadersClientInfoInterceptor (adds device metadata)
        → PrettyDioLogger                     (debug logging, disabled in prod)
        → Response
        → UnauthorizedInterceptor             (handles 401 with token refresh)
        → ForbiddenInterceptor                (handles 403, emits auth event)
```

### Token Refresh

The `UnauthorizedInterceptor` implements a **semaphore pattern** for token refresh:

1. First 401 response triggers a refresh request
2. Concurrent 401s are queued via a `Completer` (no duplicate refresh calls)
3. On success: all queued requests retry with the new token
4. On failure: `AccessTokenRefreshFailed` event emitted, triggering sign-out

### Separate Logging Client

A dedicated Dio instance handles mobile log requests — it includes only the `RequestHeadersClientInfoInterceptor` (no auth interceptor) to avoid a circular dependency with the main API client.

### Typed API Responses

All API responses are deserialized into `ApiResponse<T>` with typed `data` and `error` fields. **15+ `ApiErrorCode` values** enable context-aware error handling and localized user messages.

## Offline Support & Caching

A **3-layer data fallback** ensures the app remains functional with intermittent connectivity:

```
1. In-Memory Cache (fastest) → 2. Hive NoSQL Cache (offline) → 3. API Request (network)
```

- **Hive** persists user profile, workspaces, tasks, goals, leaderboard, and workspace users
- **Auto-recovery** — corrupted Hive cache is detected, cleared, and logged without crashing
- **FlutterSecureStorage** — access and refresh tokens stored in platform-specific encrypted storage (Keychain on iOS, Keystore on Android)
- **Paginated data** — `Paginable<T>` wrapper handles pagination metadata for task and goal lists

## Logging

The logging system uses a **delegate pattern** to switch implementations at runtime:

```
LoggerHub (delegate) → ConsoleLogger (development)
                     → RemoteLogger  (production)
```

- **ConsoleLogger** — prints to debug console in development
- **RemoteLogger** — sends `warn`/`error`/`fatal` logs to the API endpoint, which proxies them to Grafana Loki
- **Smart filtering** — excludes `GeneralApiException` (already logged server-side), timeouts, cancellations, and 4xx responses to avoid noise
- **Fire-and-forget** — logging operations never block the app; failures are silently absorbed to prevent logging loops
- **Device metadata** — OS, device model, app version, build number, and architecture are attached to every log and API request

The delegate switch is wired via `ProxyProvider2` — in release mode, the `RemoteLogger` is injected into `LoggerHub`; in debug mode, the `ConsoleLogger` remains active.

## Security

- **Frontend RBAC service** — mirrors the backend's role-based access control, conditionally showing/hiding UI elements based on workspace role (Manager/Member)
- **Encrypted token storage** — access and refresh tokens stored in platform-specific secure storage (Keychain on iOS, Keystore on Android)
- **Compile-time environment config** — `Envied` generates environment variables at build time, preventing runtime secret exposure
- **ProGuard** — enabled in Android release builds for code minification and obfuscation

## Localization

- **English** and **Croatian** translations via ARB files (`app_en.arb`, `app_hr.arb`)
- **Type-safe** — `flutter gen-l10n` generates a strongly-typed `AppLocalizations` class
- **User preference** — locale selection persisted via SharedPreferences

## UI/UX

- **Material 3** design system with a custom theme (purple primary `#5F34E2`, orange accent `#FF9142`)
- **44+ custom reusable widgets** — text fields, date pickers, select fields, sliders, header bars, and more
- **36 feature modules** — each self-contained with its own ViewModel and widgets
- **Device Preview** — development tool for testing on custom device definitions (Samsung Z Fold, tablets)
- **Toast notifications** — `toastification` for consistent success/error feedback
- **Portrait orientation** enforced across the app

## Design Decisions

**Why MVVM + Command over BLoC** — the Command pattern provides explicit action semantics (each user action maps to a named `Command`), cleaner separation than BLoC's event/state model, and aligns with the [official Flutter architecture recommendation](https://docs.flutter.dev/app-architecture/guide). BLoC introduces significant boilerplate (events, states, blocs) for every feature — Commands keep it simple.

**Why Provider over Riverpod or BLoC** — Provider handles the only two things a state management layer needs to do: reactivity (`ChangeNotifier`) and dependency injection (`ChangeNotifierProvider`, `ProxyProvider`). The MVVM architecture itself handles state scoping, separation of concerns, and testability. Using a more complex state management solution would add abstraction without adding capability — proving that **architecture matters more than tooling**.

**Why Hive over SQLite** — the local cache stores serialized domain objects for offline fallback, not relational data. Hive's NoSQL key-value model is a natural fit — no schema definitions, no migration management, just fast read/write of cached API responses.

**Why a separate Dio instance for logging** — the main API client includes an auth interceptor that depends on the auth repository, which depends on the logger service. A shared Dio instance would create a circular dependency. The logging client strips auth concerns entirely, breaking the cycle.

**Why GoRouter with StatefulShellRoute** — the app has three primary tabs that must preserve their state independently. `StatefulShellRoute` with `IndexedStack` achieves this natively. GoRouter also provides declarative deep link support, which is essential for workspace invite links shared externally.

**Why the delegate pattern for logging** — the logging implementation must change at runtime (console in dev, remote in prod) without affecting any consumer. The `LoggerHub` delegate pattern achieves this with a simple setter — no conditional logic scattered across the codebase.
```

- [ ] **Step 2: Verify the file was written**

Run: `head -5 /Users/morismoze/Documents/taskie_app/app/README.md`
Expected: First 5 lines visible

- [ ] **Step 3: Commit**

```bash
git add app/README.md
git commit -m "docs: Rewrite Flutter app README with MVVM architecture and design decisions"
```

---

### Task 4: Write Web README

**Files:**
- Create: `/web/README.md`

- [ ] **Step 1: Write the web README**

Write `/web/README.md` with the following complete content:

```markdown
# Taskie Web

<p>
  <img src="https://img.shields.io/badge/HTML5-E34F26?logo=html5&logoColor=white" alt="HTML5" />
  <img src="https://img.shields.io/badge/CSS3-1572B6?logo=css3&logoColor=white" alt="CSS3" />
  <img src="https://img.shields.io/badge/JavaScript-F7DF1E?logo=javascript&logoColor=black" alt="JavaScript" />
  <img src="https://img.shields.io/badge/PWA-5A0FC8?logo=pwa&logoColor=white" alt="PWA" />
</p>

## Overview

The Taskie web presence is a static landing page built with **pure HTML5, CSS3, and vanilla JavaScript** — zero external dependencies. It serves as the public-facing website with a feature showcase, Google Play download CTA, and legal documentation (Privacy Policy, Terms & Conditions). Deployed to a Hetzner VPS behind Nginx.

## Tech Stack

- **HTML5** — semantic markup (`<header>`, `<section>`, `<footer>`, `<nav>`)
- **CSS3** — custom properties, Grid, Flexbox, animations, transitions
- **Vanilla JavaScript** — Intersection Observer API, event handling
- **No frameworks, no libraries, no CDN requests**

## Features

- **Hero section** — animated app icon with gradient text heading and Google Play CTA
- **Feature showcase** — 4 cards (Workspaces, Tasks & Goals, Leaderboard, Team Collaboration) with scroll-triggered animations
- **Responsive layout** — CSS Grid with `repeat(auto-fit, minmax(250px, 1fr))` for automatic column adjustment
- **Legal pages** — Privacy Policy and Terms & Conditions with consistent styling
- **Google Play link** — CTA button in hero section

## Design

### CSS Architecture

- **CSS Custom Properties** for theme consistency across all pages:
  - Primary: `#6a5acd` (indigo/purple)
  - Accent: `#00d2d3` (cyan)
  - Text: `#2d3436` (dark gray)
  - Background: `#f9f9f9` (light gray)
- **Mobile-first** responsive approach with a `768px` breakpoint
- **CSS Grid** for feature card layout — auto-fit handles 1-4 columns based on viewport width
- **Flexbox** for header and alignment
- **BEM-like** class naming for maintainability

### Typography

- System font stack: Segoe UI, Tahoma, Geneva, Verdana, sans-serif
- Hero heading: 3rem (desktop) → 2.2rem (mobile)
- Body: 1rem with 1.6 line-height

## Animations & Interactivity

| Animation | Trigger | Implementation |
|-----------|---------|---------------|
| **fadeIn** | Page load | Hero section fades in over 1 second |
| **fadeInUp** | Scroll into view | Feature cards animate upward with opacity transition (0.8s) |
| **Button hover** | Mouse hover | Lift effect (`translateY(-3px)`) with expanding box shadow |
| **Card hover** | Mouse hover | Lift effect (`translateY(-5px)`) with primary border color |

All animations use **hardware-accelerated properties** (`transform`, `opacity`) to avoid layout thrashing. Scroll-triggered animations use the **Intersection Observer API** at a 10% visibility threshold — no scroll event listeners, no jank.

## PWA & Cross-Platform

- **Web App Manifest** (`site.webmanifest`) — enables "Add to Home Screen" with standalone display mode
- **Multi-resolution favicons** — 16x16, 32x32, 180x180 (Apple Touch), 192x192, 512x512 (PWA splash)
- **Android App Links** — `.well-known/assetlinks.json` verifies ownership for 3 app variants (dev, production with 2 signing configs), enabling deep links from the web to the native Flutter app

## Performance

- **Zero dependencies** — no external JavaScript or CSS libraries, no CDN requests
- **Embedded resources** — CSS and JS are embedded in each HTML file (one fewer HTTP request per resource)
- **Single HTML file per page** — entire page renders from a single server response
- **HTML minification** — the CI/CD pipeline minifies all HTML files with `html-minifier-terser` before deployment (whitespace collapsing, comment removal, inline CSS/JS minification)
- **Intersection Observer** — native browser API for lazy animation, replacing traditional scroll event listeners

## Design Decisions

**Why vanilla HTML/CSS/JS over a framework** — a landing page with 3 static pages does not need React, Vue, or any framework. Zero dependencies means instant page loads, no build tooling complexity, no JavaScript bundle to parse, and no maintenance burden from framework version updates. The result loads faster than any framework-based equivalent.

**Why embedded styles over external CSS files** — with all CSS in the HTML file, the browser renders the complete styled page from a single HTTP response. For a small landing page, this eliminates the render-blocking CSS request that an external stylesheet would introduce.

**Why Intersection Observer over scroll events** — the Intersection Observer API is a native browser API designed specifically for detecting element visibility. Unlike scroll event listeners, it runs off the main thread, doesn't fire continuously during scrolling, and requires no debouncing or throttling logic.
```

- [ ] **Step 2: Verify the file was created**

Run: `head -5 /Users/morismoze/Documents/taskie_app/web/README.md`
Expected: First 5 lines visible

- [ ] **Step 3: Commit**

```bash
git add web/README.md
git commit -m "docs: Add web landing page README with design and performance details"
```

---

### Task 5: Write CI/CD README

**Files:**
- Create: `/.github/README.md`

- [ ] **Step 1: Write the CI/CD README**

Write `/.github/README.md` with the following complete content:

```markdown
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

### SSH Deployment

The workflow SSHs into the Hetzner VPS and:

1. Pulls the new Docker image from GHCR
2. Stops and removes the current container
3. Starts the new container with `--restart always` and `--network host`
4. Updates the `.env` file from GitHub Secrets
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
  → flutter pub get → Build Runner (codegen) → gen-l10n (localization)
  → flutter analyze (--fatal-infos --fatal-warnings)
  → dart format (--set-exit-if-changed)
  → flutter test
  → flutter build apk --debug (dry run)
```

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
```

- [ ] **Step 2: Verify the file was created**

Run: `head -5 /Users/morismoze/Documents/taskie_app/.github/README.md`
Expected: First 5 lines visible

- [ ] **Step 3: Commit**

```bash
git add .github/README.md
git commit -m "docs: Add CI/CD README with pipeline details and safety mechanisms"
```

---

### Task 6: Final Review

- [ ] **Step 1: Verify all 5 README files exist**

Run: `ls -la /Users/morismoze/Documents/taskie_app/README.md /Users/morismoze/Documents/taskie_app/api/README.md /Users/morismoze/Documents/taskie_app/app/README.md /Users/morismoze/Documents/taskie_app/web/README.md /Users/morismoze/Documents/taskie_app/.github/README.md`
Expected: All 5 files listed

- [ ] **Step 2: Verify links in root README point to existing files**

Run: `ls /Users/morismoze/Documents/taskie_app/api/README.md /Users/morismoze/Documents/taskie_app/app/README.md /Users/morismoze/Documents/taskie_app/web/README.md /Users/morismoze/Documents/taskie_app/.github/README.md /Users/morismoze/Documents/taskie_app/web/logo.png /Users/morismoze/Documents/taskie_app/LICENSE`
Expected: All referenced files exist

- [ ] **Step 3: Verify git log shows all 5 commits**

Run: `git log --oneline -6`
Expected: 5 new commits (one per README) plus the spec commit
