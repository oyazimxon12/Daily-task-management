import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/qibla_screen.dart';
import 'screens/onboarding_screen.dart';
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/weather_provider.dart';
import 'l10n/app_strings.dart';
import 'services/notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// ── Design System Colors ──────────────────────────────────────────────────────
const _kPrimary   = Color(0xFF4F6EF7); // Indigo Blue
const _kSecondary = Color(0xFF31D9A4); // Mint Green
const _kError     = Color(0xFFFF6B6B); // Coral Red

// Dark mode
const _kDarkBg       = Color(0xFF0E0F1C);
const _kDarkSurface  = Color(0xFF171829);
const _kDarkSurfAlt  = Color(0xFF1E2038);
const _kDarkBorder   = Color(0xFF2A2D4A);
const _kDarkTextPri  = Color(0xFFE8EAFF);
const _kDarkTextSec  = Color(0xFF8B90B8);
const _kDarkTextMut  = Color(0xFF4A4F72);

// Light mode
const _kLightBg      = Color(0xFFF4F5FF);
const _kLightSurface = Color(0xFFFFFFFF);
const _kLightSurfAlt = Color(0xFFECEEFF);
const _kLightBorder  = Color(0xFFD8DCFF);
const _kLightTextPri = Color(0xFF131429);
const _kLightTextSec = Color(0xFF5A5F80);
const _kLightTextMut = Color(0xFF9EA3C0);
// ─────────────────────────────────────────────────────────────────────────────

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await NotificationService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider   = context.watch<ThemeProvider>();
    final localeProvider  = context.watch<LocaleProvider>();

    return AppLocalizationWrapper(
      locale: localeProvider.locale,
      child: MaterialApp(
        title: 'Smart Daily Planner',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        themeMode: themeProvider.themeMode,
        theme:     _buildLightTheme(),
        darkTheme: _buildDarkTheme(),
        initialRoute: '/splash',
        routes: {
          '/splash': (_) => const SplashScreen(),
          '/onboarding': (_) => const OnboardingScreen(),
          '/home':   (_) => const HomeScreen(),
          '/qibla':  (_) => const QiblaScreen(),
        },
      ),
    );
  }
}

// ── Dark Theme ────────────────────────────────────────────────────────────────
ThemeData _buildDarkTheme() {
  final cs = ColorScheme(
    brightness: Brightness.dark,
    primary:          _kPrimary,
    onPrimary:        Colors.white,
    primaryContainer: _kDarkSurfAlt,
    onPrimaryContainer: _kPrimary,
    secondary:        _kSecondary,
    onSecondary:      _kDarkBg,
    secondaryContainer: const Color(0xFF0E2F24),
    onSecondaryContainer: _kSecondary,
    error:            _kError,
    onError:          Colors.white,
    errorContainer:   const Color(0xFF3A1010),
    onErrorContainer: _kError,
    surface:          _kDarkSurface,
    onSurface:        _kDarkTextPri,
    surfaceContainerHighest: _kDarkSurfAlt,
    onSurfaceVariant: _kDarkTextSec,
    outline:          _kDarkBorder,
    outlineVariant:   _kDarkBorder,
    shadow:           Colors.black,
    scrim:            Colors.black54,
    inverseSurface:   _kLightSurface,
    onInverseSurface: _kLightTextPri,
    inversePrimary:   _kPrimary,
  );

  return ThemeData(
    useMaterial3:  true,
    brightness:    Brightness.dark,
    colorScheme:   cs,
    scaffoldBackgroundColor: _kDarkBg,
    cardColor:     _kDarkSurface,
    dividerColor:  _kDarkBorder,
    textTheme:     _buildTextTheme(isDark: true),
    splashFactory: InkSparkle.splashFactory,
    appBarTheme:   AppBarTheme(
      backgroundColor: _kDarkBg.withOpacity(0.8),
      foregroundColor: _kDarkTextPri,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.syne(
        fontSize: 18, fontWeight: FontWeight.w700, color: _kDarkTextPri,
      ),
    ),
    cardTheme: CardThemeData(
      color: _kDarkSurface.withOpacity(0.7),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: _kDarkBorder, width: 0.5),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _kDarkSurface.withOpacity(0.5),
      indicatorColor: _kPrimary.withOpacity(0.2),
      labelTextStyle: WidgetStateProperty.all(GoogleFonts.syne(fontSize: 11, fontWeight: FontWeight.w600)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700),
      ).copyWith(
        overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.1)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _kPrimary,
        side: const BorderSide(color: _kPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
  );
}

ThemeData _buildLightTheme() {
  final cs = ColorScheme(
    brightness: Brightness.light,
    primary:          _kPrimary,
    onPrimary:        Colors.white,
    primaryContainer: _kLightSurfAlt,
    onPrimaryContainer: _kPrimary,
    secondary:        _kSecondary,
    onSecondary:      Colors.white,
    secondaryContainer: const Color(0xFFDEFFF5),
    onSecondaryContainer: const Color(0xFF00473A),
    error:            _kError,
    onError:          Colors.white,
    errorContainer:   const Color(0xFFFFE8E8),
    onErrorContainer: const Color(0xFF8B0000),
    surface:          _kLightSurface,
    onSurface:        _kLightTextPri,
    surfaceContainerHighest: _kLightSurfAlt,
    onSurfaceVariant: _kLightTextSec,
    outline:          _kLightBorder,
    outlineVariant:   _kLightBorder,
    shadow:           Colors.black,
    scrim:            Colors.black26,
    inverseSurface:   _kDarkSurface,
    onInverseSurface: _kDarkTextPri,
    inversePrimary:   _kPrimary,
  );

  return ThemeData(
    useMaterial3:  true,
    brightness:    Brightness.light,
    colorScheme:   cs,
    scaffoldBackgroundColor: _kLightBg,
    cardColor:     _kLightSurface,
    dividerColor:  _kLightBorder,
    textTheme:     _buildTextTheme(isDark: false),
    splashFactory: InkSparkle.splashFactory,
    appBarTheme:   AppBarTheme(
      backgroundColor: _kLightBg.withOpacity(0.8),
      foregroundColor: _kLightTextPri,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.syne(
        fontSize: 18, fontWeight: FontWeight.w700, color: _kLightTextPri,
      ),
    ),
    cardTheme: CardThemeData(
      color: _kLightSurface.withOpacity(0.8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: _kLightBorder, width: 0.5),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _kLightSurface.withOpacity(0.5),
      indicatorColor: _kPrimary.withOpacity(0.1),
      labelTextStyle: WidgetStateProperty.all(GoogleFonts.syne(fontSize: 11, fontWeight: FontWeight.w600)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

TextTheme _buildTextTheme({required bool isDark}) {
  final textColor = isDark ? _kDarkTextPri : _kLightTextPri;
  final subColor  = isDark ? _kDarkTextSec : _kLightTextSec;

  return TextTheme(
    displayLarge:  GoogleFonts.syne(fontSize: 40, fontWeight: FontWeight.w800, color: textColor, letterSpacing: -1.2),
    displayMedium: GoogleFonts.syne(fontSize: 32, fontWeight: FontWeight.w800, color: textColor),
    displaySmall:  GoogleFonts.syne(fontSize: 24, fontWeight: FontWeight.w700, color: textColor),
    headlineLarge: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w700, color: textColor),
    headlineMedium:GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: textColor),
    headlineSmall: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
    titleLarge:    GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w700, color: textColor),
    titleMedium:   GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500, color: textColor),
    titleSmall:    GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500, color: subColor),
    bodyLarge:     GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w400, color: textColor, height: 1.65),
    bodyMedium:    GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w400, color: textColor),
    bodySmall:     GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w400, color: subColor),
    labelLarge:    GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.5),
    labelMedium:   GoogleFonts.syne(fontSize: 11, fontWeight: FontWeight.w700, color: subColor, letterSpacing: 0.8),
    labelSmall:    GoogleFonts.syne(fontSize: 10, fontWeight: FontWeight.w700, color: subColor, letterSpacing: 1.4),
  );
}
