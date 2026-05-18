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

  Future<WeatherData> getWeather() async {
    double lat = 41.2995, lon = 69.2401; // Toshkent default

    try {
      final pos = await _getLocation();
      lat = pos.latitude;
      lon = pos.longitude;
    } catch (_) {}

    final resp = await http.get(
      Uri.parse('$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=uz'),
    ).timeout(const Duration(seconds: 15));

    if (resp.statusCode != 200) throw Exception('Weather error \${resp.statusCode}');

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    return WeatherData(
      city: data['name'] as String,
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
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    ).timeout(const Duration(seconds: 8));
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
