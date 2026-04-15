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

- **Global ValidationPipe** with `whitelist: true` — automatically strips unknown request properties
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

**16 custom error codes** (e.g., `TASK_CLOSED`, `WORKSPACE_INVITE_EXPIRED`, `SOLE_MANAGER_CONFLICT`) enable the mobile client to display localized, context-aware error messages. All responses follow a consistent format:

```json
// Success (2xx)
{ "data": { ... }, "error": null }

// Error (4xx/5xx)
{ "data": null, "error": { "code": "7", "message": "..." } }
```

## Testing

**Jest** with **ts-jest** for unit testing:

- **Unit tests** — colocated with source files (`*.spec.ts`), covering all core services: auth, Google OAuth, workspace, workspace-user, workspace-invite, task, task-assignment, goal, session, user, and unit-of-work
- **Coverage reporting** — `npm run test:cov` generates reports in lcov, clover, and JSON formats
- **Pre-push hook** — Husky blocks `git push` if unit tests fail, preventing broken code from reaching the remote
- **Pre-commit hook** — lint-staged runs ESLint `--fix` and Prettier `--write` on staged `.ts` files

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
