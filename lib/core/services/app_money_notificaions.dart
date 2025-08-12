import 'package:flutter/material.dart';

enum DeltaKind { money, exp, custom }

class DeltaOverlay {
  DeltaOverlay._();
  static final DeltaOverlay instance = DeltaOverlay._();

  late GlobalKey<NavigatorState> _navigatorKey;
  final List<OverlayEntry> _active = [];

  void init(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  // Быстрые хелперы
  void money(int amount) => show(
    text: '${amount > 0 ? '+' : ''}$amount ₽',
    kind: DeltaKind.money,
    isNegative: amount < 0,
  );

  void exp(int amount) => show(
    text: '${amount > 0 ? '+' : ''}$amount exp',
    kind: DeltaKind.exp,
    isNegative: amount < 0,
  );

  Future<void> show({
    required String text,
    DeltaKind kind = DeltaKind.custom,
    bool isNegative = false,
    IconData? icon,
    Color? color,
    Duration duration = const Duration(milliseconds: 1400),
    double left = 16,
    double bottom = 120,
  }) async {
    final overlay = _navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    // Стиль по умолчанию
    final Color baseColor;
    final IconData baseIcon;
    switch (kind) {
      case DeltaKind.money:
        baseColor = isNegative ? Colors.red : Colors.green;
        baseIcon = Icons.currency_ruble;
        break;
      case DeltaKind.exp:
        baseColor = isNegative ? Colors.red : Colors.blue;
        baseIcon = Icons.star;
        break;
      default:
        baseColor = isNegative ? Colors.red : Colors.white;
        baseIcon = Icons.add;
    }

    // Сдвиг по активным, чтобы не перекрывались
    final idx = _active.length;
    late OverlayEntry e;
    e = OverlayEntry(
      builder: (ctx) => Positioned(
        left: left,
        bottom: bottom + (idx * 36),
        child: _DeltaToast(
          text: text,
          icon: icon ?? baseIcon,
          color: color ?? baseColor,
          duration: duration,
          onFinish: () {
            e.remove();
            _active.remove(e);
          },
        ),
      ),
    );

    _active.add(e);
    overlay.insert(e);
  }
}

class _DeltaToast extends StatefulWidget {
  const _DeltaToast({
    required this.text,
    required this.icon,
    required this.color,
    required this.duration,
    required this.onFinish,
  });

  final String text;
  final IconData icon;
  final Color color;
  final Duration duration;
  final VoidCallback onFinish;

  @override
  State<_DeltaToast> createState() => _DeltaToastState();
}

class _DeltaToastState extends State<_DeltaToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(begin: const Offset(0, 0.4), end: const Offset(0, -0.6))
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOutQuad));

    _c.forward().whenComplete(widget.onFinish);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade.drive(Tween(begin: 1.0, end: 0.0)),
      child: SlideTransition(
        position: _slide,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.75),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.color.withOpacity(0.7), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 18, color: widget.color),
                const SizedBox(width: 8),
                Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
