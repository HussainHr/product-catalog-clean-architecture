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

## Commands

```bash
flutter analyze
flutter test
```

## Submission (Kodevio)

- **Deadline:** 3 June 2026, 11:59 PM
- **API:** https://fakestoreapi.com/products
- **Email:** abdullah.kodevio@gmail.com (CC: ashif.kodevio@gmail.com)
