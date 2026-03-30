# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter-based Enterprise Resource Planning (ERP) application for construction project management called "MR Constructions". It provides a mobile solution for managing construction projects with features like Gate Pass management, Project tracking, Daily Reporting, Gate Entry system, and Goods Received Notes (GRN).

## Common Development Commands

### Flutter Setup

```bash
flutter pub get
```
Install project dependencies.

```bash
flutter pub upgrade
```
Upgrade project dependencies.

### Running the App

```bash
flutter run -d android
```
Run the app on an Android device/emulator.

```bash
flutter run -d ios
```
Run the app on an iOS device/simulator.

```bash
flutter run -d web
```
Run the app in a web browser.

### Code Generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
Generate Retrofit API clients and JSON serializers.

```bash
flutter pub run build_runner watch
```
Watch for changes and regenerate code as needed.

### Testing

```bash
flutter test
```
Run all tests.

```bash
flutter test test/your_test_file.dart
```
Run a specific test file.

```bash
flutter test test/your_test_file.dart -r expanded
```
Run tests with detailed output.

### Linting and Formatting

```bash
flutter analyze
```
Run static code analysis.

```bash
flutter format .
```
Format all Dart files in the project.

## Architecture

### High-Level Structure

The project follows a feature-based modular architecture:

```
lib/
└── ERP/
    ├── api/                # API layer - models and services
    │   ├── models/          # Data models with JSON serialization
    │   └── services/        # API service interfaces and implementations
    ├── bloc/               # Business logic layer - BLoC pattern
    │   ├── AuthenticationBloc/
    │   ├── DailyReporting/
    │   ├── DropDownValueBloc/
    │   ├── GateEntry/
    │   ├── GatePass/
    │   ├── GoodsReceivedNotesBloc/
    │   └── ProjectBloc/
    ├── data/               # Data layer - local storage and repositories
    │   └── local/
    └── ui/                 # UI layer - pages and widgets
        ├── Pages/          # Feature pages organized by domain
        │   ├── Authentication/
        │   ├── DailyReporting/
        │   ├── Dashbaord/
        │   ├── GateEntry/
        │   ├── GatePass/
        │   ├── GoodsReceivedNotes/
        │   ├── Projects/
        │   └── Starter/
        └── Widgets/         # Reusable UI components
```

### Key Features

1. **Authentication**: OTP-based login system
2. **Gate Pass Management**: Create, view, and manage gate passes
3. **Project Management**: Track and manage construction projects
4. **Daily Reporting**: Record daily progress, material consumption, and machine readings
5. **Gate Entry System**: Monitor in-out movements of vehicles and personnel
6. **Goods Received Notes**: Record and verify incoming materials

### Role-Based Access Control

The application implements role-based access control with three user roles:

- **Project Manager**: Full access to all features
- **Project Coordinator**: Access to Gate Pass, Projects, Daily Reporting, and GRN
- **Project Sub-Coordinator**: Access to Gate Entry and Daily Reporting only

### State Management

The app uses the **BLoC (Business Logic Component)** pattern with the `flutter_bloc` package for state management. Each feature has its own BLoC implementation.

### API Communication

The project uses **Retrofit** with **Dio** for type-safe API communication. API services are defined as interfaces with annotations and generated at build time.

### Local Storage

User preferences, authentication tokens, and role information are stored locally using `shared_preferences`.

## Development Notes

### Code Generation

This project uses code generation for:
- JSON serialization (json_serializable)
- Retrofit API clients (retrofit_generator)

After modifying any model or API service interface, run the build runner to regenerate the code.

### Responsive Design

The app uses the `sizer` package for responsive design. UI components should use responsive units to adapt to different screen sizes.

### Internationalization

The `intl` package is used for date formatting and localization. Custom date formats can be defined in utility classes.

### Testing Strategy

Tests should follow the standard Flutter testing patterns:
- Widget tests for UI components
- BLoC tests for business logic
- Unit tests for utility functions
- Integration tests for end-to-end flows

## Important Files

- `lib/main.dart`: Application entry point
- `lib/ERP/ui/Pages/Dashbaord/Home.dart`: Main dashboard with role-based menu
- `lib/ERP/data/local/AppUtils.dart`: Utility class for local storage operations
- `lib/ERP/Utils/colors_constants.dart`: Application color scheme

## Dependencies

Key dependencies include:
- flutter_bloc: State management
- retrofit + dio: API communication
- shared_preferences: Local storage
- sizer: Responsive design
- google_fonts: Typography
- font_awesome_flutter: Iconography
- fluttertoast: Toast notifications
- flutter_otp_text_field: OTP input

## Backend Integration

The app communicates with a backend API. API services are defined in `lib/ERP/api/services/` and generated using Retrofit. Models are located in `lib/ERP/api/models/` with corresponding `.g.dart` generated files.
