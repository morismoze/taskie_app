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
