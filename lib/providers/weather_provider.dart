import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherData? _weather;
  bool _loading = false;
  String? _error;

  WeatherData? get weather => _weather;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> load({String locale = 'en'}) async {
    if (_loading) return;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _weather = await WeatherService().getWeather(locale: locale);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
