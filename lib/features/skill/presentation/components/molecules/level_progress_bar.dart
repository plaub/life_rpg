import 'package:flutter/material.dart';

class LevelProgressBar extends StatelessWidget {
  final int currentXp;
  final int requiredXp;
  final double height;

  const LevelProgressBar({
    super.key,
    required this.currentXp,
    required this.requiredXp,
    this.height = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = requiredXp > 0
        ? (currentXp / requiredXp).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(height / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: FractionallySizedBox(
        widthFactor: progress,
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
            ),
            borderRadius: BorderRadius.circular(height / 2),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
