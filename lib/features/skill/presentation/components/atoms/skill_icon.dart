import 'package:flutter/material.dart';

class SkillIcon extends StatelessWidget {
  final String icon;
  final String? colorHex;
  final double size;
  final double fontSize;

  const SkillIcon({
    super.key,
    required this.icon,
    this.colorHex,
    this.size = 56.0,
    this.fontSize = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Parse hex color or fallback to primary
    Color backgroundColor = theme.primaryColor;
    if (colorHex != null && colorHex!.isNotEmpty) {
      try {
        backgroundColor = Color(int.parse('0xFF$colorHex'));
      } catch (_) {}
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(size / 3),
        border: Border.all(
          color: backgroundColor.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Text(icon, style: TextStyle(fontSize: fontSize)),
    );
  }
}
