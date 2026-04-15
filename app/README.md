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
- **Stream helpers** — `firstOkOrLastError` and `lastOkOrLastError` utility functions for handling multi-emit async streams from the 3-layer cache fallback
- **Observable state** — `.running`, `.error`, `.completed` properties for UI binding

ViewModels extend `ChangeNotifier` and expose `Command` objects. Views observe the ViewModel and react to command state changes — no manual state flags, no boilerplate.

### Layer Structure

The folder structure follows the [official Flutter architecture case study](https://docs.flutter.dev/app-architecture/case-study), adapted to the project's domain:

```
lib/
├── config/
│   ├── dependencies.dart    # Provider setup (DI container)
│   ├── environment/         # Compile-time env config (Envied)
│   └── api_endpoints.dart   # API route constants
├── data/
│   ├── repositories/        # 13 domain repositories (ChangeNotifier)
│   └── services/
│       ├── api/             # Dio clients, interceptors, response models
│       ├── external/        # Firebase, Google Sign-In
│       └── local/           # Hive, SecureStorage, SharedPreferences, EventBus
├── domain/
│   ├── models/              # 15 domain models (json_serializable)
│   ├── use_cases/           # 8 use cases (multi-repo orchestration)
│   └── constants/           # RBAC rules, validation, business rules
├── ui/
│   ├── core/
│   │   ├── theme/           # Colors, typography, dimensions
│   │   ├── ui/              # 44+ reusable custom widgets
│   │   ├── l10n/            # Localization (EN, HR)
│   │   └── services/        # RBAC service
│   └── [feature]/           # 34 feature modules
│       ├── view_models/     # ChangeNotifier ViewModels
│       └── widgets/         # Feature-specific UI
├── routing/                 # GoRouter config, route constants
├── logger/                  # Logger interface, hub, console, remote
└── utils/                   # Command pattern, LRU cache (LinkedHashMap-based with eviction)
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

- **StatefulShellRoute with IndexedStack** — tab content persists when switching between tabs (no rebuild, no transition animation)
- **Global redirect** — auth state changes trigger navigation via `Listenable.merge` on the auth repository
- **Custom transitions** — `SharedAxisTransition` with semantic durations: scaled (250ms) for detail screens, horizontal (400ms) for create/edit flows
- **Provider memoization** — routes wrapped with `ChangeNotifierProvider` that prevent ViewModel reinstantiation when navigating between routes at the same workspace level
- **Back button handler** — hierarchical handling: closes drawer if open, navigates to Tasks tab from other tabs, double-tap-to-exit with 2-second debounce on root screens via `SystemNavigator.pop()`
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

### Multi-Stage Atomic Sign-Out

Sign-out follows a deliberate ordering: `isAuthenticated` is set to `false` **first** (triggering route guards immediately), then tokens are cleared, cache is purged, and external auth providers are signed out. This prevents any UI from accessing stale auth state during the teardown sequence.

### Auth Event Bus

An `AuthEventBus` implements a pub/sub pattern using a broadcast `StreamController` for distributed auth state updates. Three sealed event types — `UserRoleChangedEvent`, `UserRemovedFromWorkspaceEvent`, and `AccessTokenRefreshFailed` — are emitted by interceptors and consumed by the `AuthEventListener` widget, which handles sign-out, workspace switching, or user profile refresh accordingly.

### Permission Change Detection

The `ForbiddenInterceptor` detects workspace access revocation and role changes via API error codes. It uses a **3-second debounce semaphore** to prevent cascading event emissions when multiple 403 responses arrive simultaneously (e.g., parallel requests all failing after a role change).

### Separate Logging Client

A dedicated Dio instance handles mobile log requests — it includes only the `RequestHeadersClientInfoInterceptor` (no auth interceptor) to avoid a circular dependency with the main API client.

### Typed API Responses

All API responses are deserialized into `ApiResponse<T>` with typed `data` and `error` fields. **16 `ApiErrorCode` values** enable context-aware error handling and localized user messages. A `ValuePatch<T>` wrapper distinguishes between "not provided" and "explicitly null" in PATCH requests, enabling precise partial updates.

## App Lifecycle & Startup

- **`AppStartup`** widget pre-loads critical data (client info, auth state) before rendering the UI, preventing loading screens and data races
- **`AppLifecycleStateListener`** with `WidgetsBindingObserver` monitors foreground/background transitions — on app resume (with a 2-second debounce), it compares the previous user state against the server to detect silent role changes or workspace access revocation using a sealed `CheckUserResult` type
- **`LocaleInitializer`** persists and restores the user's locale preference on startup

## Pagination & Filtering

- **`Paginable<T>`** generic wrapper for paginated API responses with metadata (total items, page count)
- **`ObjectiveFilter`** extends `Filter` with status filtering and `SortBy` enum for sorting tasks and goals
- **`number_paginator`** package provides visible page number controls in the UI
- **Deterministic sorting** — assignee lists sorted by `firstName → lastName → ID` for consistent ordering across sessions
- Search, filter, and sort state managed within ViewModels for reactive updates

## Offline Support & Caching

A **3-layer data fallback** ensures the app remains functional with intermittent connectivity:

```
1. In-Memory Cache (fastest) → 2. Hive NoSQL Cache (offline) → 3. API Request (network)
```

- **Async generators** (`async*`) in repositories yield cached states progressively — in-memory first, then Hive, then API — so the UI updates optimistically before the network response arrives
- **Hive** persists user profile, workspaces, tasks, goals, leaderboard, and workspace users
- **Auto-recovery** — corrupted Hive cache is detected, cleared, and logged without crashing
- **Two-tier token storage** — tokens are cached in-memory for fast access and persisted to `FlutterSecureStorage` (Keychain on iOS, Keystore on Android) with **rollback on write failure** — if secure storage write fails, the in-memory cache is reverted to prevent state divergence
- **Paginated data** — `Paginable<T>` wrapper handles pagination metadata for task and goal lists
- **Repository-level pagination state** — repositories auto-adjust the current page when filters change (reset to page 1) and auto-load the previous page when the current page becomes empty after item deletion

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

- **Frontend RBAC service** — mirrors the backend's role-based access control with 7 granular permissions (workspace delete, settings manage, users create/edit/remove, objective create/edit), using `Selector<RbacService, bool>` for fine-grained reactivity — UI components rebuild only when their specific permission outcome changes
- **Google Auth flows** — supports **silent sign-in** (automatic re-authentication on app restart) and **interactive sign-in** (user-initiated), with **external provider state cleanup** — if the backend login fails after Google authentication succeeds, the Google session is explicitly revoked to prevent auth state divergence
- **Encrypted token storage** — access and refresh tokens stored in platform-specific secure storage (Keychain on iOS, Keystore on Android)
- **Compile-time environment config** — `Envied` generates environment variables at build time with **XOR obfuscation**, preventing runtime secret exposure and making secrets harder to extract from compiled binaries
- **ProGuard** — enabled in Android release builds for code minification and obfuscation
- **Build flavors** — development (`com.taskie.taskie.dev`) and production (`com.taskie.taskie`) with separate signing configurations and app names
- **Client-side validation rules** — workspace names (3-50 chars), objective titles (3-50 chars), descriptions (max 250 chars), task assignees (1-10), reward points (10-50 in steps of 10), invite token format (24-char hex regex)

## Localization

- **English** and **Croatian** translations via ARB files (`app_en.arb`, `app_hr.arb`)
- **Type-safe** — `flutter gen-l10n` generates a strongly-typed `AppLocalizations` class
- **User preference** — locale selection persisted via SharedPreferences

## UI/UX

- **Material 3** design system with a custom theme (purple primary `#5F34E2`, orange accent `#FF9142`)
- **44+ custom reusable widgets** — text fields, date pickers, select fields, sliders, header bars, and more
- **34 feature modules** — each self-contained with its own ViewModel and widgets
- **Device Preview** — development tool for testing on custom device definitions (Samsung Z Fold, tablets)
- **Toast notifications** — `toastification` for consistent success/error feedback
- **Portrait orientation** enforced across the app
- **Cached network images** — workspace images loaded with `cached_network_image` for efficient caching
- **Native sharing** — workspace invite links shared via `share_plus` using the platform's native share sheet
- **URL launching** — external links opened via `url_launcher`

## Design Decisions

**Why MVVM + Command over BLoC** — the Command pattern provides explicit action semantics (each user action maps to a named `Command`), cleaner separation than BLoC's event/state model, and aligns with the [official Flutter architecture recommendation](https://docs.flutter.dev/app-architecture/guide). BLoC introduces significant boilerplate (events, states, blocs) for every feature — Commands keep it simple.

**Why Provider over Riverpod or BLoC** — Provider handles the only two things a state management layer needs to do: reactivity (`ChangeNotifier`) and dependency injection (`ChangeNotifierProvider`, `ProxyProvider`). The MVVM architecture itself handles state scoping, separation of concerns, and testability. Using a more complex state management solution would add abstraction without adding capability — proving that **architecture matters more than tooling**.

**Why Hive over SQLite** — the local cache stores serialized domain objects for offline fallback, not relational data. Hive's NoSQL key-value model is a natural fit — no schema definitions, no migration management, just fast read/write of cached API responses.

**Why a separate Dio instance for logging** — the main API client includes an auth interceptor that depends on the auth repository, which depends on the logger service. A shared Dio instance would create a circular dependency. The logging client strips auth concerns entirely, breaking the cycle.

**Why GoRouter with StatefulShellRoute** — the app has three primary tabs that must preserve their state independently. `StatefulShellRoute` with `IndexedStack` achieves this natively. GoRouter also provides declarative deep link support, which is essential for workspace invite links shared externally.

**Why the delegate pattern for logging** — the logging implementation must change at runtime (console in dev, remote in prod) without affecting any consumer. The `LoggerHub` delegate pattern achieves this with a simple setter — no conditional logic scattered across the codebase.
