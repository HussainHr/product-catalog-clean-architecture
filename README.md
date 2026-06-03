# Product Catalog

Flutter technical assessment — product listing, details, search, and favorites.

**Stack:** Clean Architecture, MVVM, Riverpod

## Quick start

```bash
flutter pub get
flutter run
```

## Project layout

```
lib/
├── main.dart
├── app.dart
├── core/                  # Shared infra (theme, errors, network, storage, widgets)
└── features/
    ├── products/          # data / domain / presentation
    ├── favorites/
    └── theme/
```

Each feature follows Clean Architecture: **domain → data → presentation**.

State management uses **StateNotifier + State class** for list, favorites, and theme. DI stays in Riverpod `Provider`.

Tests mirror the same layout under `test/features/`.

## Development status

| Sprint | Status |
|--------|--------|
| 0      | Baseline shell |
| 1      | Riverpod + theme + folder structure |
| 2      | Domain layer (entities, repositories, use cases) |
| 3      | Data layer (API model, remote DS, repository impl) |
| 4      | Riverpod DI (providers wired) |
| 5      | Products list (loading, error, empty, cached images) |
| 6      | Product detail screen + navigation |
| 7      | Pull-to-refresh on product listing |
| 8      | Local search by product title |
| 9      | Favorites persistence + UI |
| 10     | UI polish + responsive layout |
| 11     | Infinite pagination (FakeStore limit/offset) |
| 12     | Dark / light theme with persistence |

## Commands

```bash
flutter analyze
flutter test
```
