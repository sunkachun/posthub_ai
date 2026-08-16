# PostHub — Development Workflow & Architecture

> Documentation of the development process, project structure, and key technical
> decisions behind **PostHub**, a Clean Architecture Flutter client for
> [JSONPlaceholder](https://jsonplaceholder.typicode.com).

---

## 1. Project Directory Structure

The codebase follows **Clean Architecture** with a **Feature-First** presentation
layer. The three core layers live under `lib/` (`domain`, `data`, `presentation`),
with tests mirroring the source layout under `test/`.

```text
posthub_by_ai/
├── .github/
│   └── workflows/
│       └── ci.yml                          # GitHub Actions CI (analyze + test)
│       └── release.yml                     # GitHub Release
├── lib/
│   ├── main.dart                           # Composition root (DI)
│   ├── app.dart                            # MaterialApp.router + BlocProvider
│   ├── core/                               # Shared infrastructure
│   │   ├── errors/
│   │   │   └── server_exception.dart       # Custom ServerException
│   │   ├── router/
│   │   │   └── app_router.dart             # go_router configuration
│   │   └── widgets/
│   │       ├── error_retry_view.dart       # Offline/error UI w/ Retry
│   │       └── post_image.dart             # CachedNetworkImage wrapper
│   ├── domain/                             # ★ DOMAIN LAYER (no dependencies)
│   │   ├── entities/
│   │   │   ├── comment.dart                # CommentEntity
│   │   │   ├── post.dart                   # PostEntity (+ imageUrl getter)
│   │   │   └── user.dart                   # UserEntity
│   │   └── repositories/
│   │       └── post_repository.dart        # Abstract PostRepository contract
│   ├── data/                               # ★ DATA LAYER (DTOs, sources, impls)
│   │   ├── datasources/
│   │   │   ├── api_post_data_source.dart   # http.Client → JSONPlaceholder
│   │   │   └── mock_post_data_source.dart  # Static in-memory JSON
│   │   ├── models/
│   │   │   ├── comment_dto.dart            # CommentDto.fromJson/toEntity
│   │   │   ├── post_dto.dart               # PostDto.fromJson/toEntity
│   │   │   └── user_dto.dart               # UserDto.fromJson/toEntity
│   │   └── repositories/
│   │       ├── api_post_repository_impl.dart   # Real API + N+1 resolution
│   │       └── mock_post_repository_impl.dart  # Mock-first implementation
│   └── presentation/                       # ★ PRESENTATION LAYER (BLoC + Views)
│       └── features/
│           └── post/
│               ├── bloc/
│               │   ├── post_bloc.dart      # PostBloc (events → states)
│               │   ├── post_event.dart     # PostFetched/LoadMore/Comments
│               │   └── post_state.dart     # PostState + PostStatus enum
│               └── view/
│                   ├── post_detail_screen.dart
│                   └── post_list_screen.dart
└── test/
    ├── widget_test.dart                    # Smoke test (mock repository)
    ├── data/
    │   └── api_post_repository_test.dart   # N+1 mapping + ServerException
    ├── domain/
    │   └── post_repository_test.dart       # Mock repo parsing + N+1
    └── presentation/
        └── post_bloc_test.dart             # BLoC state transitions
```

---

## 2. Development Workflow

The project was delivered in incremental phases, each leaving the codebase in a
working, testable state.

### Phase 1 — Domain Entities & Abstract Repository (Mock-First)
- Defined pure domain entities: `PostEntity` (with a non-nullable `author`),
  `UserEntity`, and `CommentEntity` using `equatable`.
- Declared the abstract `PostRepository` contract (`fetchPosts`, `fetchPostDetail`,
  `fetchComments`) returning entities only.
- Built `MockPostDataSource` (static JSON) and `MockPostRepositoryImpl`, allowing
  the UI to be developed against realistic data before any real networking.

### Phase 2 — State Management, Routing & UI Skeleton
- Introduced `PostBloc` with pagination (`PostFetched`, `PostLoadMore`) and
  comment loading (`PostCommentsFetched`), backed by a single `PostState`.
- Configured `go_router` (`AppRouter`) and wired `PostBloc` globally above
  `MaterialApp.router` so all routes can access it.
- Created `PostListScreen` and `PostDetailScreen` with loading/error/empty states,
  shimmer skeletons, and pull-to-refresh.

### Phase 3 — Real API Integration (JSONPlaceholder)
- Implemented `ApiPostDataSource` (using `http.Client`) for posts, users, and
  comments, throwing `ServerException` on non-200 responses.
- **Critical N+1 API Problem solved** in `ApiPostRepositoryImpl`:
  1. Await `fetchPosts`.
  2. Deduplicate `userId`s into a `Set`.
  3. `Future.wait` to fetch users **concurrently**.
  4. Map raw posts + users into `List<PostEntity>`.
- Added dynamic image URL generation (`picsum.photos/seed/{id}/200/150`) and the
  Android `INTERNET` permission.
- Switched the composition root in `main.dart` from `MockPostRepositoryImpl` to
  `ApiPostRepositoryImpl`.

### Phase 4 — DevOps & Quality Gates
- Added `.github/workflows/ci.yml` running `flutter analyze` and `flutter test`
  on every push and pull request to `main` (Ubuntu, Flutter stable).
- Wrote unit tests for JSON parsing, N+1 mapping, BLoC transitions, and a widget
  smoke test.

### Phase 4.5 — Continuous Deployment (CD)
- Added `.github/workflows/release.yml` for automated releases.
- Pushing a tag matching `v*` (e.g., `v1.0.1`) triggers a `build-and-release` job
  that builds a release APK (`flutter build apk --release`) and attaches it to a
  GitHub Release for easy download.

### Phase 5 — Documentation & Tag Release
- Authored `README.md` (project overview, stack, features, run/test commands) and
  this `workflow.md` (structure + process + decisions).
- The codebase is tagged and ready for a release.

---

## 3. Key Technical Decisions

### Why Clean Architecture?
Separating `domain`, `data`, and `presentation` makes the business logic
independent of frameworks and data sources. The `domain` layer has zero
dependencies, so swapping the mock for the real API (or adding a cache) only
touches the `data` layer — the UI and BLoC remain untouched.

### Why BLoC?
BLoC provides a unidirectional, event-driven data flow with immutable state,
making screen behavior predictable and unit-testable (`bloc_test`). Combined with
`go_router`, it cleanly separates navigation from state management.

### How the N+1 Problem Was Solved
The posts endpoint returns only a `userId`, not the author object. Naively
fetching each author per post would trigger N extra requests. Instead:

1. Aggregate unique `userId`s into a `Set` (deduplication).
2. Fetch all unique users **concurrently** with `Future.wait`.
3. Build a `Map<int, UserEntity>` and attach each author to its post.

This reduces the number of requests from `N` to the number of *distinct* authors,
and performs those requests in parallel rather than sequentially.
