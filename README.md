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
├── main.dart              # ProviderScope entry
├── app.dart               # MaterialApp root
├── core/                  # Theme, constants, errors
├── domain/                # Entities, repositories, use cases
├── data/                  # Models, data sources, repo impl
└── presentation/          # Screens, widgets, Riverpod providers
```

## Development status

| Sprint | Status |
|--------|--------|
| 0 | Baseline shell |
| 1 | Riverpod + theme + folder structure |
| 2 | Domain layer (entities, repositories, use cases) |
| 3 | Data layer (API model, remote DS, repository impl) |
| 4 | Riverpod DI (providers wired) |
| 5 | Products list (loading, error, empty, cached images) |
| 6 | Product detail screen + navigation |
| 7 | Pull-to-refresh on product listing |
| 8 | Local search by product title |

## Commands

```bash
flutter analyze
flutter test
```
