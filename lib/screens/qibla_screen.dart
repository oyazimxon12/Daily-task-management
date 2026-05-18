import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../l10n/app_strings.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> with SingleTickerProviderStateMixin {
  // Makkaning koordinatalari
  static const double _meccaLat = 21.3891;
  static const double _meccaLon = 39.8579;

  double? _qiblaBearing;
  String? _cityName;
  bool _loading = true;
  String? _error;

  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _getQibla();
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  Future<void> _getQibla() async {
    setState(() { _loading = true; _error = null; });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() { _error = 'location_service'; _loading = false; });
        return;
      }
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) {
          setState(() { _error = 'permission'; _loading = false; });
          return;
        }
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      final bearing = _calculateBearing(pos.latitude, pos.longitude, _meccaLat, _meccaLon);
      setState(() {
        _qiblaBearing = bearing;
        _cityName = _getCityApprox(pos.latitude, pos.longitude);
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  double _calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    final dLon = _toRad(lon2 - lon1);
    final y = math.sin(dLon) * math.cos(_toRad(lat2));
    final x = math.cos(_toRad(lat1)) * math.sin(_toRad(lat2)) -
        math.sin(_toRad(lat1)) * math.cos(_toRad(lat2)) * math.cos(dLon);
    final bearing = math.atan2(y, x);
    return ((_toDeg(bearing) + 360) % 360);
  }

  double _toRad(double deg) => deg * math.pi / 180;
  double _toDeg(double rad) => rad * 180 / math.pi;

  String _getCityApprox(double lat, double lon) {
    if (lat > 37 && lat < 46 && lon > 55 && lon < 73) return 'O\'zbekiston';
    if (lat > 37 && lat < 42 && lon > 68 && lon < 73) return 'Toshkent';
    if (lat > 38 && lat < 42 && lon > 63 && lon < 68) return 'Samarqand';
    return '${lat.toStringAsFixed(2)}°N, ${lon.toStringAsFixed(2)}°E';
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.qibla),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _getQibla),
        ],
      ),
      body: _loading
          ? Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(s.locationLoading),
              ],
            ))
          : _error != null
              ? _buildError(s)
              : _buildCompass(s, colorScheme),
    );
  }

  Widget _buildError(AppStrings s) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              _error == 'permission' ? s.locationPermission : s.locationError,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _getQibla,
              icon: const Icon(Icons.refresh),
              label: Text(s.locationLoading),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompass(AppStrings s, ColorScheme colorScheme) {
    final bearing = _qiblaBearing!;
    final bearingRad = _toRad(bearing);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (_cityName != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 4),
                    Text(_cityName!, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            const SizedBox(height: 32),

            // Compass
            SizedBox(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer ring
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colorScheme.outline, width: 2),
                      color: colorScheme.surface,
                      boxShadow: [
                        BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.15), blurRadius: 16, spreadRadius: 2),
                      ],
                    ),
                  ),
                  // Cardinal directions
                  ..._buildCardinals(colorScheme),
                  // Qibla arrow
                  Transform.rotate(
                    angle: bearingRad,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.mosque, color: Colors.white, size: 22),
                        ),
                        Container(
                          width: 3,
                          height: 70,
                          color: Colors.green,
                        ),
                        Container(
                          width: 3,
                          height: 30,
                          color: Colors.red.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),
                  // Center dot
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.mosque, color: Colors.green, size: 28),
                        const SizedBox(width: 10),
                        Text(
                          s.qiblaDirection,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${bearing.toStringAsFixed(1)}° ${s.qiblaDegrees}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Makka al-Mukarrama',
                      style: TextStyle(color: colorScheme.outline),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCardinals(ColorScheme colorScheme) {
    const dirs = [('N', 0.0), ('E', 90.0), ('S', 180.0), ('W', 270.0)];
    return dirs.map((d) {
      final angle = _toRad(d.$2);
      const r = 120.0;
      final x = r * math.sin(angle);
      final y = -r * math.cos(angle);
      return Positioned(
        left: 140 + x - 12,
        top: 140 + y - 12,
        child: Text(
          d.$1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: d.$1 == 'N' ? Colors.red : colorScheme.onSurface,
          ),
        ),
      );
    }).toList();
  }
}
