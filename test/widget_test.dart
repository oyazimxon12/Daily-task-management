// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_daily_planner/main.dart';
import 'package:smart_daily_planner/providers/locale_provider.dart';
import 'package:smart_daily_planner/providers/task_provider.dart';
import 'package:smart_daily_planner/providers/theme_provider.dart';
import 'package:smart_daily_planner/providers/weather_provider.dart';

void main() {
  testWidgets('app builds with required providers', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
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

    await tester.pump(const Duration(milliseconds: 2500));

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
