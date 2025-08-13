

import 'dart:math' as math;

import 'package:flutter/material.dart';

class TracerBullet extends StatefulWidget {
  final bool fromLeft; // true: слева -> вправо
  final bool miss;     // true: промах (слегка вверх + поворот)
  final VoidCallback onDone;

  const TracerBullet({
    super.key,
    required this.fromLeft,
    required this.onDone,
    required this.miss,
  });

  @override
  State<TracerBullet> createState() => _TracerBulletState();
}

class _TracerBulletState extends State<TracerBullet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<Alignment> _align;

  // Максимальный угол поворота при промахе (радианы)
  static const double _missMaxAngle = 12 * math.pi / 180; // ~12°

  @override
  void initState() {
    super.initState();

    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    // Чуть вверх по Y в конце траектории при miss
    final double endY = widget.miss ? -0.08 : 0.0;

    _align = AlignmentTween(
      begin: widget.fromLeft
          ? const Alignment(-0.7, 0.0)
          : const Alignment( 0.9, 0.0),
      end: widget.fromLeft
          ? Alignment( 0.7, endY)
          : Alignment(-0.9, endY),
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));

    _c.addStatusListener((s) {
      if (s == AnimationStatus.completed) widget.onDone();
    });

    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double targetAngle = widget.miss
        ? (widget.fromLeft ? -_missMaxAngle : _missMaxAngle)
        : 0.0;

    return IgnorePointer(
      ignoring: true,
      child: SizedBox.expand(
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, __) {
            final angle = targetAngle * _c.value; // 0 -> targetAngle
            return AlignTransition(
              alignment: _align,
              child: Transform.rotate(
                angle: angle,
                child: Container(
                  width: 22,
                  height: 6,
                  decoration: BoxDecoration(
                    color: widget.fromLeft ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: const [BoxShadow(blurRadius: 8, spreadRadius: 1)],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
