import 'dart:math';
import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';

void showCompletionCelebration(BuildContext context) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (ctx) => _CelebrationWidget(onDone: () {
      if (entry.mounted) entry.remove();
    }),
  );
  overlay.insert(entry);
}

class _CelebrationWidget extends StatefulWidget {
  final VoidCallback onDone;
  const _CelebrationWidget({required this.onDone});

  @override
  State<_CelebrationWidget> createState() => _CelebrationWidgetState();
}

class _CelebrationWidgetState extends State<_CelebrationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _particles = _buildParticles();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _scale = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.15)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 55,
      ),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 15),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
    ]).animate(_ctrl);

    _fade = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 55),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_ctrl);

    _ctrl.forward().then((_) => widget.onDone());
  }

  List<_Particle> _buildParticles() {
    final rand = Random();
    const colors = [
      Colors.amber, Colors.green, Colors.blue, Colors.pink,
      Colors.orange, Colors.purple, Colors.teal, Colors.red,
      Colors.cyan, Colors.lime,
    ];
    return List.generate(28, (_) => _Particle(
      angle: rand.nextDouble() * 2 * pi,
      speed: 120 + rand.nextDouble() * 220,
      color: colors[rand.nextInt(colors.length)],
      size: 5 + rand.nextDouble() * 7,
      isSquare: rand.nextBool(),
    ));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) => IgnorePointer(
        child: Stack(
          children: [
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: _ParticlePainter(_ctrl.value, _particles),
            ),
            Center(
              child: Opacity(
                opacity: _fade.value.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: _scale.value.clamp(0.0, 2.0),
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.green.shade500,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.45),
                          blurRadius: 24,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_rounded, color: Colors.white, size: 52),
                        const SizedBox(height: 2),
                        Text(
                          s.doneAnimation,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  final List<_Particle> particles;

  const _ParticlePainter(this.progress, this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.05 || progress > 0.95) return;
    final t = ((progress - 0.05) / 0.9).clamp(0.0, 1.0);
    final center = Offset(size.width / 2, size.height / 2);

    for (final p in particles) {
      final opacity = (1 - t * t).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = p.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      final dx = cos(p.angle) * p.speed * t;
      final dy = sin(p.angle) * p.speed * t - 180 * t * t;
      final pos = Offset(center.dx + dx, center.dy + dy);
      final r = p.size * (1 - t * 0.4);

      if (p.isSquare) {
        canvas.save();
        canvas.translate(pos.dx, pos.dy);
        canvas.rotate(t * pi * 3);
        canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: r * 2, height: r * 2), paint);
        canvas.restore();
      } else {
        canvas.drawCircle(pos, r, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

class _Particle {
  final double angle;
  final double speed;
  final Color color;
  final double size;
  final bool isSquare;

  const _Particle({
    required this.angle,
    required this.speed,
    required this.color,
    required this.size,
    required this.isSquare,
  });
}
