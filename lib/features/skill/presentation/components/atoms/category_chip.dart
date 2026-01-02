import 'package:flutter/material.dart';
import '../../../domain/entities/skill_category.dart';

class CategoryChip extends StatelessWidget {
  final SkillCategory category;

  const CategoryChip({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Parse color or fallback
    Color categoryColor = theme.colorScheme.primary;
    if (category.color.isNotEmpty) {
      try {
        categoryColor = Color(int.parse('0xFF${category.color}'));
      } catch (_) {}
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: categoryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: categoryColor.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(category.icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            category.name,
            style: theme.textTheme.labelSmall?.copyWith(
              color: categoryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
