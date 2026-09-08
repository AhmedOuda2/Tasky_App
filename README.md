# Tasky - Task Management App 📝

A task management mobile application built with **Flutter** following **Clean Architecture**.

## 📱 Features
- **CRUD Operations**: Create, Read, Update, and Delete tasks.
- **Search & Dynamic Filter**: Search by title and filter by Category and Status.
- **Form Validation**: Validation for task title, description, and due date.
- **Local Storage**: Persistent offline storage using `shared_preferences`.
- **State Management**: Reactive UI with `Provider` and `ChangeNotifier`.

## 📦 Packages Used
- `provider`: State Management.
- `shared_preferences`: Local Data Persistence.
- `intl`: Date formatting.

## 💾 Local Storage Strategy
- Tasks are modeled via `TaskModel` with JSON serialization (`toMap` / `fromMap`).
- Saved locally as a serialized JSON string in `shared_preferences`.
- Restored automatically on app launch.

## 🔄 State Management
- Managed through `TaskController` extending `ChangeNotifier`.
- Centralized business logic separating UI from state changes.

## 🚀 How to Run
```bash
flutter pub get
flutter run