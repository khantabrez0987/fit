# Fitness App - Professional Project Structure

This document describes the professional-level project structure implemented in this Flutter application.

## Directory Structure

```
lib/
├── core/                           # Core app functionality
│   ├── constants/
│   │   ├── app_constants.dart      # App-wide constants
│   │   └── app_strings.dart        # String constants
│   ├── routes/
│   │   ├── app_router.dart         # Router configuration
│   │   └── app_routes.dart        # Route constants
│   ├── theme/
│   │   ├── app_theme.dart          # Theme configuration
│   │   └── app_colors.dart         # Color definitions
│   └── utils/
│       └── validators.dart         # Form validators
│
├── features/                       # Feature modules
│   ├── auth/
│   │   ├── data/                  # Data layer (repositories, data sources)
│   │   ├── domain/                 # Domain layer (models, use cases)
│   │   └── presentation/
│   │       ├── pages/             # Auth screens
│   │       ├── widgets/          # Auth-specific widgets
│   │       └── providers/        # Auth state management
│   │
│   ├── home/
│   │   └── presentation/
│   │       └── pages/
│   │
│   ├── workouts/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── nutrition/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── profile/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── onboarding/
│       └── presentation/
│           └── pages/
│
├── shared/                         # Shared across features
│   ├── models/                    # Shared data models
│   │   ├── exercise.dart
│   │   ├── workout.dart
│   │   ├── nutrition.dart
│   │   ├── user.dart
│   │   └── models.dart            # Barrel export
│   └── widgets/                  # Reusable widgets
│
├── providers/                      # Legacy providers (to be migrated)
├── screens/                        # Legacy screens (to be migrated)
├── services/                       # Business logic services
└── main.dart                      # App entry point
```

## Architecture Principles

### 1. Feature-Based Architecture
Each feature is self-contained with its own:
- **Data Layer**: Repositories, data sources, API clients
- **Domain Layer**: Business logic, entities, use cases
- **Presentation Layer**: UI (pages, widgets), state management (providers/notifiers)

### 2. Separation of Concerns
- **Core**: App-wide constants, themes, routes, utilities
- **Features**: Feature-specific code organized by layer
- **Shared**: Code used across multiple features

### 3. Dependency Direction
```
Presentation → Domain ← Data
      ↓
    Shared
      ↓
     Core
```

## Key Files

### Core Files
- `core/constants/app_constants.dart`: Numeric constants, default values
- `core/constants/app_strings.dart`: Localized strings
- `core/theme/app_theme.dart`: Light/dark theme configuration
- `core/routes/app_router.dart`: Navigation configuration

### Feature Modules
Each feature follows the same structure:
- `presentation/pages/`: Screen widgets
- `presentation/widgets/`: Feature-specific widgets
- `presentation/providers/`: State management
- `domain/`: Business logic and entities
- `data/`: Data access layer

### Shared Resources
- `shared/models/`: Data models used across features
- `shared/widgets/`: Reusable UI components

## Migration Status

✅ **Completed:**
- Core structure (constants, theme, routes, utils)
- Auth feature module structure
- Onboarding feature
- Shared models
- Main app setup

🔄 **In Progress:**
- Migrating remaining screens to feature modules
- Updating imports across the project

📋 **Todo:**
- Complete feature module migrations
- Add domain layer (use cases, repositories)
- Add data layer (API clients, local storage)
- Create shared widgets library
- Add error handling utilities

## Best Practices

1. **Imports**: Use barrel exports (`models.dart`) when possible
2. **Naming**: Use descriptive names, follow Dart conventions
3. **Separation**: Keep business logic in domain layer
4. **Reusability**: Place shared code in `shared/` or `core/`
5. **Testing**: Mirror structure in `test/` directory

## Next Steps

1. Complete migration of all screens to feature modules
2. Implement clean architecture layers (data, domain, presentation)
3. Add dependency injection
4. Implement proper error handling
5. Add comprehensive testing structure

