import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

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
    final isDark = theme.brightness == Brightness.dark;
    final progress = requiredXp > 0
        ? (currentXp / requiredXp).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: FractionallySizedBox(
          widthFactor: progress,
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColors.progressStartDark, AppColors.progressEndDark]
                    : [AppColors.progressStart, AppColors.progressEnd],
              ),
              borderRadius: BorderRadius.circular(height / 2),
              boxShadow: [
                BoxShadow(
                  color:
                      (isDark
                              ? AppColors.progressStartDark
                              : AppColors.progressStart)
                          .withValues(alpha: 0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
