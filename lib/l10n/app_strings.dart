import 'package:flutter/material.dart';

class AppStrings {
  final String locale;
  AppStrings(this.locale);

  static AppStrings of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<_LocaleInheritedWidget>();
    return provider?.strings ?? AppStrings('uz');
  }

  String get appTitle => _t('Smart Daily Planner', 'Smart Daily Planner', 'Smart Daily Planner');
  String get welcomeBack => _t('Xush kelibsiz!', 'С возвращением!', 'Welcome Back');
  String get signIn => _t('Hisobingizga kiring', 'Войдите в аккаунт', 'Sign in to your account');
  String get email => _t('Email', 'Эл. почта', 'Email');
  String get password => _t('Parol', 'Пароль', 'Password');
  String get login => _t('Kirish', 'Войти', 'Login');
  String get noAccount => _t('Hisobingiz yo\'qmi?', 'Нет аккаунта?', 'No account?');
  String get register => _t('Ro\'yxatdan o\'tish', 'Зарегистрироваться', 'Register');
  String get emailPasswordRequired => _t('Email va parol kiritilishi shart', 'Email и пароль обязательны', 'Email and password required');
  String get createAccount => _t('Hisob yaratish', 'Создать аккаунт', 'Create Account');
  String get joinApp => _t('Smart Daily Planner\'ga qo\'shiling', 'Присоединяйтесь к Smart Daily Planner', 'Join Smart Daily Planner');
  String get username => _t('Foydalanuvchi nomi', 'Имя пользователя', 'Username');
  String get confirmPassword => _t('Parolni tasdiqlang', 'Подтвердите пароль', 'Confirm Password');
  String get allFieldsRequired => _t('Barcha maydonlar to\'ldirilishi shart', 'Все поля обязательны', 'All fields are required');
  String get passwordsDoNotMatch => _t('Parollar mos kelmaydi', 'Пароли не совпадают', 'Passwords do not match');
  String get alreadyHaveAccount => _t('Hisobingiz bormi?', 'Уже есть аккаунт?', 'Already have account?');
  String get home => _t('Bosh sahifa', 'Главная', 'Home');
  String get calendar => _t('Kalendar', 'Календарь', 'Calendar');
  String get tasks => _t('Vazifalar', 'Задачи', 'Tasks');
  String get logout => _t('Chiqish', 'Выйти', 'Logout');
  String get addTask => _t('Yangi vazifa qo\'shish', 'Добавить задачу', 'Add New Task');
  String get taskTitle => _t('Vazifa nomi', 'Название задачи', 'Task Title');
  String get description => _t('Izoh', 'Описание', 'Description');
  String get cancel => _t('Bekor qilish', 'Отмена', 'Cancel');
  String get add => _t('Qo\'shish', 'Добавить', 'Add');
  String get todaysTasks => _t('Bugungi vazifalar', 'Задачи на сегодня', 'Today\'s Tasks');
  String get completed => _t('Bajarilgan', 'Выполнено', 'Completed');
  String get pending => _t('Kutilmoqda', 'Ожидает', 'Pending');
  String get allTasks => _t('Barcha vazifalar', 'Все задачи', 'All Tasks');
  String get noTasksToday => _t('Bugun vazifa yo\'q. Yangisini qo\'shing!', 'Нет задач на сегодня. Создайте!', 'No tasks for today. Create one!');
  String get noTasksYet => _t('Hali vazifa yo\'q. Yangisini qo\'shing!', 'Задач пока нет. Создайте!', 'No tasks yet. Create one!');
  String get noTasksForDate => _t('Bu sanada vazifa yo\'q', 'Нет задач на эту дату', 'No tasks for this date');
  String get calendarView => _t('Kalendar ko\'rinishi', 'Вид календаря', 'Calendar View');
  String get tasksForSelectedDate => _t('Tanlangan sana uchun vazifalar', 'Задачи на выбранную дату', 'Tasks for Selected Date');
  String get taskAdded => _t('Vazifa qo\'shildi!', 'Задача добавлена!', 'Task added successfully!');
  String get taskDeleted => _t('Vazifa o\'chirildi', 'Задача удалена', 'Task deleted');
  String get errorLoadingTasks => _t('Vazifalarni yuklashda xato', 'Ошибка загрузки задач', 'Error loading tasks');
  String get selectDate => _t('Sanani tanlang', 'Выберите дату', 'Select Date');
  String get selectTime => _t('Vaqtni tanlang (ixtiyoriy)', 'Выберите время (необязательно)', 'Select Time (Optional)');
  String get date => _t('Sana', 'Дата', 'Date');
  String get time => _t('Vaqt', 'Время', 'Time');
  String get category => _t('Kategoriya', 'Категория', 'Category');
  String get darkMode => _t('Tungi rejim', 'Тёмный режим', 'Dark Mode');
  String get lightMode => _t('Kunduzgi rejim', 'Светлый режим', 'Light Mode');
  String get language => _t('Til', 'Язык', 'Language');
  String get settings => _t('Sozlamalar', 'Настройки', 'Settings');
  String get work => _t('Ish', 'Работа', 'Work');
  String get exercise => _t('Mashq', 'Упражнения', 'Exercise');
  String get study => _t('O\'qish', 'Учёba', 'Study');
  String get prayer => _t('Namoz', 'Намаз', 'Prayer');
  String get hydration => _t('Suv ichish', 'Вода', 'Hydration');
  String get other => _t('Boshqa', 'Другое', 'Other');
  String get titleRequired => _t('Nom kiritilishi shart', 'Введите название', 'Title is required');

  // AI Assistant
  String get aiAssistant => _t('AI Yordamchi', 'AI Ассистент', 'AI Assistant');
  String get aiOnline => _t('● Onlayn', '● Онлайн', '● Online');
  String get askAi => _t('Savol bering...', 'Задайте вопрос...', 'Ask a question...');

  // Qibla
  String get qibla => _t('Qibla', 'Кибла', 'Qibla');
  String get qiblaDirection => _t('Qibla yo\'nalishi', 'Направление Киблы', 'Qibla Direction');
  String get qiblaDegrees => _t('daraja shimoldan', 'градусов от севера', 'degrees from north');
  String get locationLoading => _t('Joylashuv aniqlanmoqda...', 'Определение местоположения...', 'Getting location...');
  String get locationError => _t('Joylashuvni aniqlashda xato', 'Ошибка геолокации', 'Location error');
  String get locationPermission => _t('Joylashuv ruxsati kerak', 'Требуется доступ к геолокации', 'Location permission needed');

  // Weather
  String get weather => _t('Ob-havo', 'Погода', 'Weather');
  String get humidity => _t('Namlik', 'Влажность', 'Humidity');
  String get wind => _t('Shamol', 'Ветер', 'Wind');
  String get weatherApiNote => _t('OpenWeather API ulang', 'Подключите OpenWeather API', 'Connect OpenWeather API');

  // Profile/Settings
  String get profile => _t('Sozlamalar', 'Настройки', 'Settings');
  String get editProfile => _t('Profilni tahrirlash', 'Редактировать профиль', 'Edit Profile');
  String get save => _t('Saqlash', 'Сохранить', 'Save');
  String get accountInfo => _t('Hisob ma\'lumotlari', 'Данные аккаунта', 'Account Info');
  String get appSettings => _t('Ilova sozlamalari', 'Настройки приложения', 'App Settings');
  String get notifications => _t('Bildirishnomalar', 'Уведомления', 'Notifications');
  String get about => _t('Ilova haqida', 'О приложении', 'About');
  String get version => _t('Versiya', 'Версия', 'Version');

  // Dashboard
  String get goodMorning => _t('Xayrli tong', 'Доброе утро', 'Good morning');
  String get goodAfternoon => _t('Xayrli kun', 'Добрый день', 'Good afternoon');
  String get goodEvening => _t('Xayrli kech', 'Добрый вечер', 'Good evening');
  String get dailyProgress => _t('Kunlik progress', 'Дневной прогресс', 'Daily Progress');
  String get aiSuggestions => _t('AI tavsiyalar', 'Рекомендации AI', 'AI Suggestions');
  String get seeAll => _t('Hammasini ko\'rish', 'Посмотреть все', 'See all');
  String get noSuggestions => _t('Ajoyib! Hamma vazifalar bajarilgan.', 'Отлично! Все задачи выполнены.', 'Great! All tasks completed.');

  // Voice & Verification
  String get voiceInput => _t('Ovozli kiritish', 'Голосовой ввод', 'Voice Input');
  String get listening => _t('Tinglayapman...', 'Слушаю...', 'Listening...');
  String get addProof => _t('Tasdiq qo\'shish', 'Добавить доказательство', 'Add Proof');
  String get proofAdded => _t('Tasdiq qo\'shildi', 'Доказательство добавлено', 'Proof added');
  String get takePhoto => _t('Rasm olish', 'Сделать фото', 'Take Photo');
  String get choosePhoto => _t('Galereyadan tanlash', 'Выбрать из галереи', 'Choose from Gallery');

  // Navigation
  String get navHome => _t('Bosh', 'Главная', 'Home');
  String get navTasks => _t('Vazifalar', 'Задачи', 'Tasks');
  String get navCalendar => _t('Kalendar', 'Календарь', 'Calendar');
  String get navAi => _t('AI', 'AI', 'AI');
  String get navProfile => _t('Sozlamalar', 'Настройки', 'Settings');

  // Filters
  String get filterAll => _t('Hammasi', 'Все', 'All');
  String get filterDone => _t('Bajarilgan', 'Выполнено', 'Done');
  String get filterPending => _t('Kutilmoqda', 'Ожидает', 'Pending');
  String get filterMissed => _t('O\'tib ketgan', 'Пропущено', 'Missed');
  String get pastTimeError => _t('O\'tib ketgan vaqtga vazifa qo\'shib bo\'lmaydi', 'Нельзя добавить задачу на прошедшее время', 'Cannot add task for past time');

  // Onboarding & Celebration
  String get doneAnimation => _t('Bajarildi!', 'Выполнеno!', 'Done!');
  String get getStarted => _t('Boshladik', 'Начать', 'Get Started');
  String get next => _t('Keyingisi', 'Далее', 'Next');
  String get skip => _t('O\'tkazib yuborish', 'Пропустить', 'Skip');
  
  String get obTitle1 => _t('Aqlli Rejalashtiruvchi', 'Умный планировщик', 'Smart Planner');
  String get obDesc1 => _t('Kunlik vazifalaringizni osongina boshqaring va samaradorlikni oshiring.', 'Легко управляйте ежедневными задачами и повышайте продуктивность.', 'Manage your daily tasks easily and boost your productivity.');
  
  String get obTitle2 => _t('AI Yordamchi', 'AI Ассистент', 'AI Assistant');
  String get obDesc2 => _t('Sun\'iy intelekt sizga vazifalarni rejalashtirishda va tavsiyalar berishda yordam beradi.', 'Искусственный интеллект поможет вам планировать задачи и давать рекомендации.', 'AI helps you plan tasks and provides smart recommendations.');
  
  String get obTitle3 => _t('Hamma narsa bir joyda', 'Все в одном месте', 'Everything in one place');
  String get obDesc3 => _t('Kalendar, ob-havo, qibla va ovozli kiritish - hammasi siz uchun.', 'Календарь, погода, кибла и голосовой ввод — все для вас.', 'Calendar, weather, qibla, and voice input - all in one place.');

  List<String> get categories => [work, exercise, study, prayer, hydration, other];

  String _t(String uz, String ru, String en) {
    switch (locale) {
      case 'ru': return ru;
      case 'en': return en;
      default: return uz;
    }
  }
}

class _LocaleInheritedWidget extends InheritedWidget {
  final AppStrings strings;

  const _LocaleInheritedWidget({
    required this.strings,
    required super.child,
  });

  @override
  bool updateShouldNotify(_LocaleInheritedWidget oldWidget) =>
      oldWidget.strings.locale != strings.locale;
}

class AppLocalizationWrapper extends StatelessWidget {
  final String locale;
  final Widget child;

  const AppLocalizationWrapper({
    super.key,
    required this.locale,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return _LocaleInheritedWidget(
      strings: AppStrings(locale),
      child: child,
    );
  }
}
