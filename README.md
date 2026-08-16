<p align="center">
  <h1 align="center">PostHub</h1>
  <p align="center">A Clean Architecture Flutter client for <a href="https://jsonplaceholder.typicode.com">JSONPlaceholder</a>.</p>
</p>

<p align="center">
  <a href="https://github.com/OWNER/posthub_by_ai/actions">
    <img src="https://github.com/OWNER/posthub_by_ai/actions/workflows/ci.yml/badge.svg" alt="CI">
  </a>
  <img src="https://img.shields.io/badge/Flutter-stable-02569B?logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/architecture-Clean-0a9396" alt="Clean Architecture">
  <img src="https://img.shields.io/badge/state-BLoC-8a2be2" alt="BLoC">
</p>

---

## Tech Stack

| Layer | Technology |
| --- | --- |
| Framework | **Flutter** (stable channel) |
| Architecture | **Clean Architecture** + Feature-First |
| State Management | **BLoC** (`flutter_bloc` + `equatable`) |
| Routing | **go_router** |
| Networking | **http** |
| Testing | **Mocktail** (`flutter_test`, `bloc_test`) |

## Key Features

- **Pagination** — 10 posts per page with infinite scroll (load-more) and pull-to-refresh.
- **N+1 API Problem handled** — unique `userId`s are aggregated and authors fetched concurrently via `Future.wait`, then mapped onto each `PostEntity` before reaching the UI.
- **Dynamic Image Generation** — each post's image URL is derived from its ID (`picsum.photos/seed/{id}`).
- **Global Error Handling** — offline/error UI with a retry action, plus shimmer skeletons and image fallbacks.

## Architecture Flow

The codebase is separated into three layers to isolate concerns:

```
UI (Presentation)  ──▶  Domain  ◀──  Data
   BLoC + Views         Entities        DTOs, DataSources, Repositories
                        Repository (abstract)
```

- **Domain** — pure entities (`PostEntity`, `UserEntity`, `CommentEntity`) and the abstract `PostRepository` contract. Depends on nothing.
- **Data** — DTOs with JSON parsing, `ApiPostDataSource` / `MockPostDataSource`, and repository implementations that resolve the N+1 mapping and translate DTOs into entities.
- **Presentation** — BLoC state management, screens, and shared widgets. Depends only on the `PostRepository` abstraction, injected at the composition root.

## How to Run & Test

```bash
# Install dependencies
flutter pub get

# Run the app (real API)
flutter run

# Static analysis
flutter analyze

# Run the test suite
flutter test
```
