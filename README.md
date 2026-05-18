# Smart Daily Planner - Flutter Mobile App

A beautiful and easy-to-use mobile application for managing daily tasks with AI assistance, calendar view, and smart reminders.

## Features

✅ **Dashboard** - View today's tasks and statistics
✅ **Calendar View** - Navigate tasks by date
✅ **Task Management** - Add, edit, delete, and mark tasks as complete
✅ **Task Categories** - Organize tasks by type (Work, Exercise, Study, Prayer, Hydration, etc.)
✅ **Simple & User-Friendly** - Easy to navigate interface

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── task.dart            # Task data model
├── providers/
│   └── task_provider.dart   # State management with Provider
└── screens/
    ├── home_screen.dart     # Home/Dashboard screen
    ├── calendar_screen.dart # Calendar view screen
    └── tasks_list_screen.dart # All tasks screen
```

## Installation & Setup

### Prerequisites
- Flutter SDK (3.0 or higher)
- Android Studio or VS Code
- Android emulator or physical device

### Step 1: Clone/Copy the Project
The project is located at: `c:\Users\User\Desktop\daily-task-management\smart_daily_planner`

### Step 2: Install Dependencies
Open terminal in the project directory and run:

```bash
flutter pub get
```

This will install all required packages:
- `provider` - State management
- `intl` - Internationalization
- `table_calendar` - Calendar widget
- `uuid` - Generate unique IDs
- `shared_preferences` - Local storage

### Step 3: Run the App

**On Android Emulator:**
```bash
flutter run
```

**On Physical Device:**
Connect your Android device and run:
```bash
flutter run
```

## How to Use

1. **Home Tab** - View today's tasks and overall progress
2. **Calendar Tab** - Select dates and view tasks for those dates
3. **Tasks Tab** - View all your tasks in a list
4. **Add Task** - Click the blue "+" button to create a new task
5. **Mark Complete** - Check the checkbox to mark tasks as done
6. **Delete Task** - Click the trash icon to remove a task

## Building for Release

To create a release APK for Android:

```bash
flutter build apk --release
```

The APK will be available at:
`build/app/outputs/flutter-apk/app-release.apk`

## Future Enhancements

- [ ] AI-powered task recommendations
- [ ] Voice input for task creation
- [ ] Push notifications and reminders
- [ ] Photo/video verification for task completion
- [ ] Weather integration
- [ ] Pulse monitoring
- [ ] Qibla direction finder
- [ ] Cloud sync with Firebase

## Technology Stack

- **Framework**: Flutter (Dart)
- **State Management**: Provider
- **Local Storage**: SharedPreferences
- **IDE**: VS Code / Android Studio

## Troubleshooting

**Issue: "Flutter command not found"**
- Add Flutter to your PATH environment variable

**Issue: Emulator won't start**
- Check if you have Android emulator configured in Android Studio

**Issue: Build errors**
- Run `flutter clean` then `flutter pub get` and try again

## Support

For more information about Flutter, visit: https://flutter.dev

## License

This project is open source and available for personal and educational use.

---

**Happy Planning! 🎯📅✨**
