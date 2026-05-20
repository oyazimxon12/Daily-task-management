import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherData {
  final String city;
  final double temp;
  final String condition;
  final String icon;
  final int humidity;
  final double windSpeed;

  const WeatherData({
    required this.city,
    required this.temp,
    required this.condition,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });
}

class WeatherService {
  static String get _apiKey => dotenv.env['WEATHER_API_KEY'] ?? '';
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const _geoUrl = 'http://api.openweathermap.org/geo/1.0';

  Future<WeatherData> getWeather({String locale = 'en'}) async {
    double lat = 41.2995, lon = 69.2401; // Toshkent default

    try {
      final pos = await _getLocation();
      lat = pos.latitude;
      lon = pos.longitude;
    } catch (_) {}

    // OpenWeatherMap supports 'ru' and 'en'; 'uz' falls back to English
    final lang = locale == 'ru' ? 'ru' : 'en';

    // Fetch weather data and proper city name in parallel
    final results = await Future.wait([
      http.get(
        Uri.parse('$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=$lang'),
      ).timeout(const Duration(seconds: 15)),
      http.get(
        Uri.parse('$_geoUrl/reverse?lat=$lat&lon=$lon&limit=1&appid=$_apiKey'),
      ).timeout(const Duration(seconds: 15)),
    ]);

    if (results[0].statusCode != 200) throw Exception('Weather error ${results[0].statusCode}');

    final data = jsonDecode(results[0].body) as Map<String, dynamic>;

    // Get proper city name from Geocoding API (not the neighborhood from weather API)
    String cityName = data['name'] as String;
    if (results[1].statusCode == 200) {
      final geoList = jsonDecode(results[1].body) as List;
      if (geoList.isNotEmpty) {
        final geo = geoList[0] as Map<String, dynamic>;
        // Prefer localized name (uz/ru), fallback to English name
        final localNames = geo['local_names'] as Map<String, dynamic>?;
        if (locale == 'ru' && localNames?['ru'] != null) {
          cityName = localNames!['ru'] as String;
        } else if (localNames?['en'] != null) {
          cityName = localNames!['en'] as String;
        } else {
          cityName = geo['name'] as String? ?? cityName;
        }
      }
    }

    return WeatherData(
      city: cityName,
      temp: (data['main']['temp'] as num).toDouble(),
      condition: data['weather'][0]['description'] as String,
      icon: _iconFromCode(data['weather'][0]['id'] as int),
      humidity: data['main']['humidity'] as int,
      windSpeed: (data['wind']['speed'] as num).toDouble(),
    );
  }

  Future<Position> _getLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) throw Exception('disabled');
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) throw Exception('denied');
    }
    if (perm == LocationPermission.deniedForever) throw Exception('denied forever');
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 8),
      ),
    );
  }

  String _iconFromCode(int code) {
    if (code >= 200 && code < 300) return '⛈️';
    if (code >= 300 && code < 400) return '🌦️';
    if (code >= 500 && code < 600) return '🌧️';
    if (code >= 600 && code < 700) return '❄️';
    if (code >= 700 && code < 800) return '🌫️';
    if (code == 800) return '☀️';
    return '⛅';
  }
}
