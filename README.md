# Smart Daily Planner - Flutter Mobile App 📱

A powerful and beautiful mobile application for managing daily tasks with **AI assistance**, **calendar view**, **smart reminders**, **weather integration**, **Qibla finder**, and **voice input**.

![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-blue)
![License](https://img.shields.io/badge/License-MIT-green)

---

## ✨ Features

### Core Task Management
✅ **Smart Dashboard** - View today's tasks with statistics and progress tracking  
✅ **Calendar View** - Navigate and manage tasks by date  
✅ **Task Management** - Add, edit, delete, and mark tasks as complete  
✅ **Task Categories** - Organize tasks by type (Work, Exercise, Study, Prayer, Hydration, etc.)  
✅ **Task Details** - Rich task information with completion celebration animations  

### Advanced Features
🤖 **AI Assistance** - AI-powered task recommendations and insights  
🎤 **Voice Input** - Create tasks using voice-to-text technology  
📸 **Image Picker** - Attach photos to tasks  
🌤️ **Weather Integration** - Real-time weather information and integration  
📍 **Qibla Finder** - Show Qibla direction for prayer times  
📊 **Charts & Statistics** - Visual representation of task completion  

### User Experience
🌙 **Dark/Light Theme** - Beautiful dark and light mode support  
🌍 **Multi-Language Support** - Localization support (Uzbek, English, etc.)  
💾 **Local Storage** - All data saved locally with SharedPreferences  
✨ **Smooth Animations** - Completion celebrations and transitions  
📱 **Responsive Design** - Optimized for all screen sizes  

---

## 📁 Project Structure

```
lib/
├── main.dart                        # App entry point with theme and providers setup
├── l10n/
│   └── app_strings.dart            # Localization strings for multi-language support
├── models/
│   └── task.dart                   # Task data model
├── providers/
│   ├── task_provider.dart          # Task state management
│   ├── theme_provider.dart         # Dark/Light theme management
│   ├── locale_provider.dart        # Language/Localization management
│   └── weather_provider.dart       # Weather data provider
├── screens/
│   ├── splash_screen.dart          # Splash/Welcome screen
│   ├── onboarding_screen.dart      # Onboarding tutorial
│   ├── home_screen.dart            # Dashboard with tasks overview
│   ├── calendar_screen.dart        # Calendar view for date-based tasks
│   ├── tasks_list_screen.dart      # Complete tasks list
│   ├── ai_screen.dart              # AI assistant and recommendations
│   ├── qibla_screen.dart           # Qibla direction finder
│   └── profile_screen.dart         # User profile and settings
├── services/
│   ├── ai_service.dart             # AI API integration
│   └── weather_service.dart        # Weather API integration
└── widgets/
    ├── completion_celebration.dart # Celebration animation widget
    └── task_detail_sheet.dart      # Task detail bottom sheet
```

---

## 🚀 Installation & Setup

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.0.0 or higher) - [Download](https://flutter.dev/docs/get-started/install)
- **Dart** (included with Flutter)
- **Android Studio** or **Visual Studio Code**
- **Android SDK** (API level 23+) or **iOS deployment target** (11+)
- **Git** (optional, for cloning)

#### Check Flutter Installation
```bash
flutter --version
flutter doctor
```

---

### Step 1: Get the Project

**Option A: Clone from Git (if available)**
```bash
git clone <repository-url>
cd Daily-task-management
```

**Option B: Download Project**
Navigate to the project directory manually or copy the project files to your desired location.

---

### Step 2: Install Dependencies

Open terminal/command prompt in the project directory and run:

```bash
flutter pub get
```

This will install all required packages listed in `pubspec.yaml`:

| Package | Version | Purpose |
|---------|---------|---------|
| `provider` | ^6.0.0 | State management |
| `intl` | ^0.20.2 | Internationalization |
| `uuid` | ^4.0.0 | Generate unique IDs for tasks |
| `shared_preferences` | ^2.2.0 | Local storage for data persistence |
| `http` | ^1.1.0 | HTTP requests for APIs |
| `flutter_dotenv` | ^5.2.1 | Environment variables (.env file) |
| `google_fonts` | ^6.1.0 | Beautiful Google Fonts |
| `geolocator` | ^13.0.2 | Location services for Qibla finder |
| `speech_to_text` | ^7.0.0 | Voice-to-text functionality |
| `image_picker` | ^1.1.2 | Pick images from gallery/camera |
| `fl_chart` | ^0.68.0 | Beautiful charts for statistics |
| `percent_indicator` | ^4.2.3 | Progress indicators |

---

### Step 3: Configure Environment Variables

Create a `.env` file in the project root directory with your API keys:

```bash
# .env file
WEATHER_API_KEY=your_weather_api_key_here
AI_API_KEY=your_ai_api_key_here
```

This file is used by `flutter_dotenv` to load environment variables securely.

---

### Step 4: Run the Application

#### On Android Emulator

1. Start Android Emulator from Android Studio
2. Run the app:
   ```bash
   flutter run
   ```

#### On Physical Android Device

1. Connect your Android device via USB
2. Enable Developer Mode and USB Debugging on your device
3. Run the app:
   ```bash
   flutter run
   ```

#### On iOS (macOS only)

1. Install iOS dependencies:
   ```bash
   flutter pub get
   cd ios
   pod install
   cd ..
   ```
2. Run the app:
   ```bash
   flutter run -d ios
   ```

#### Run in Release Mode (Optimized)

```bash
flutter run --release
```

---

## 📖 How to Use

### Navigation

1. **Home Tab** 🏠 - View today's tasks and overall progress statistics
2. **Calendar Tab** 📅 - Select dates and view tasks scheduled for those dates
3. **Tasks Tab** ✅ - View complete list of all tasks
4. **AI Tab** 🤖 - Get AI-powered recommendations and insights
5. **Qibla Tab** 📍 - Find Qibla direction (prayer direction)
6. **Profile Tab** 👤 - Access settings, theme, and language options

### Managing Tasks

**Create a New Task**
- Tap the blue **"+"** button
- Enter task title and description
- Select a category (Work, Exercise, Study, etc.)
- Choose date and time
- Optionally add voice input or image
- Tap **Save**

**Edit Task**
- Swipe or long-press on a task
- Select **Edit**
- Make changes
- Tap **Save**

**Mark Task as Complete**
- Tap the checkbox next to the task
- See the completion celebration animation!
- Task will show as completed

**Delete Task**
- Swipe or long-press on a task
- Select **Delete** (trash icon)
- Confirm deletion

**View Task Details**
- Tap on any task to see full details
- View task history and completion status

### Customization

**Change Theme**
1. Go to **Profile** → **Settings**
2. Toggle between **Dark Mode** and **Light Mode**

**Change Language**
1. Go to **Profile** → **Settings**
2. Select your preferred language

---

## 🏗️ Building for Release

### Build Android APK

**Debug APK (for testing):**
```bash
flutter build apk --debug
```

**Release APK (for production):**
```bash
flutter build apk --release
```

**App Bundle (for Google Play):**
```bash
flutter build appbundle --release
```

Output locations:
- APK: `build/app/outputs/flutter-apk/`
- App Bundle: `build/app/outputs/bundle/release/`

### Build for iOS

```bash
flutter build ios --release
```

---

## 🛠️ Development

### Code Structure Best Practices

- **Models**: Define data structures in `lib/models/`
- **Providers**: State management in `lib/providers/`
- **Screens**: UI pages in `lib/screens/`
- **Services**: External API calls in `lib/services/`
- **Widgets**: Reusable UI components in `lib/widgets/`

### Hot Reload & Hot Restart

**Hot Reload** (fastest, doesn't reset state):
```bash
r
```

**Hot Restart** (restarts the entire app):
```bash
R
```

---

## 🧪 Testing

Run tests with:
```bash
flutter test
```

For coverage analysis:
```bash
flutter test --coverage
```

---

## 📚 Technology Stack

| Technology | Version | Purpose |
|-----------|---------|---------|
| **Flutter** | 3.0+ | UI Framework |
| **Dart** | 3.0+ | Programming Language |
| **Provider** | ^6.0.0 | State Management |
| **SharedPreferences** | ^2.2.0 | Local Data Storage |
| **HTTP** | ^1.1.0 | API Requests |
| **fl_chart** | ^0.68.0 | Data Visualization |

---

## 🎯 Future Enhancements

- [ ] Push notifications and reminders
- [ ] Cloud sync with Firebase
- [ ] Photo/video verification for task completion
- [ ] Pulse/heart rate monitoring integration
- [ ] Collaborative task management
- [ ] Task templates library
- [ ] Recurring tasks with smart scheduling
- [ ] Offline-first sync
- [ ] Export to PDF/Excel

---

## 🐛 Troubleshooting

### Issue: "Flutter not found"
**Solution:**
```bash
flutter --version
export PATH="$PATH:`pwd`/flutter/bin"
```

### Issue: "Gradle build fails"
**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: "Pod install fails" (iOS)
**Solution:**
```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
flutter run
```

### Issue: "Device not recognized"
**Solution:**
```bash
flutter devices
flutter run -d <device-id>
```

---

## 📄 File Descriptions

### Configuration Files

- **`pubspec.yaml`** - Project dependencies and configuration
- **`.env`** - Environment variables (API keys)
- **`.metadata`** - Flutter project metadata
- **`analysis_options.yaml`** - Dart analysis rules
- **`devtools_options.yaml`** - DevTools configuration

### Build Files

- **`android/`** - Android-specific configuration
- **`ios/`** - iOS-specific configuration (if available)
- **`web/`** - Web deployment configuration
- **`build/`** - Build output directory

### Assets

- **`assets/images/`** - Images and graphics

---

## 📝 Code Examples

### Creating a Task

```dart
Task newTask = Task(
  id: uuid.v4(),
  title: 'Complete project',
  description: 'Finish the Flutter app',
  category: 'Work',
  dueDate: DateTime.now().add(Duration(days: 1)),
  isCompleted: false,
);

// Add via Provider
context.read<TaskProvider>().addTask(newTask);
```

### Using Theme Provider

```dart
// Get current theme
bool isDarkMode = context.watch<ThemeProvider>().isDarkMode;

// Toggle theme
context.read<ThemeProvider>().toggleTheme();
```

### Changing Language

```dart
// Change locale
context.read<LocaleProvider>().setLocale(Locale('uz', 'UZ'));
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 📧 Support & Contact

For questions, issues, or suggestions:
- Open an issue on GitHub
- Contact the development team

---

## 🙏 Acknowledgments

- Flutter and Dart teams for the amazing framework
- All contributors and users of this project
- Open-source community for the awesome packages

---

**Happy Task Management! 🚀**
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
