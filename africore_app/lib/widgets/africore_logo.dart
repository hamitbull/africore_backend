import 'package:flutter/material.dart';

class AfricoreLogo extends StatelessWidget {
  final double size;
  final bool showWordmark;

  const AfricoreLogo({super.key, this.size = 40, this.showWordmark = false});

  @override
  Widget build(BuildContext context) {
    final mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: const LinearGradient(
          colors: [Color(0xFF00D6B5), Color(0xFF087F8C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00BFA6).withOpacity(0.22),
            blurRadius: size * 0.22,
            offset: Offset(0, size * 0.07),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.public_rounded,
          size: size * 0.62,
          color: const Color(0xFF071321),
        ),
      ),
    );

    if (!showWordmark) return mark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        const SizedBox(height: 12),
        const Text(
          'AFRICORE',
          style: TextStyle(
            color: Color(0xFF071321),
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'ONE AFRICA. ONE PLATFORM.',
          style: TextStyle(
            color: Color(0xFF087F8C),
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
      ],
    );
  }
}
