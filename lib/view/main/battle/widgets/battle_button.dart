import 'package:flutter/material.dart';

class BattleButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onTap;
  final Widget? child;
  const BattleButton({super.key, this.width = 48, this.height = 48, required this.onTap, this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.white.withAlpha(80),
          border: Border.all(color: Colors.white.withAlpha(183)),
        ),
        child: Center(child: child),
      ),
    );
  }
}

