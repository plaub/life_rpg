import 'package:flutter/material.dart';
import 'package:life_rpg/core/i18n/app_localizations.dart';

class XPLabel extends StatelessWidget {
  final int current;
  final int total;
  final bool showLabel;

  const XPLabel({
    super.key,
    required this.current,
    required this.total,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Text.rich(
      TextSpan(
        style: theme.textTheme.bodySmall,
        children: [
          TextSpan(
            text: '$current',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          TextSpan(
            text: ' / $total',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (showLabel)
            TextSpan(
              text: ' ${l10n.xpLabel}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 10,
                color: theme.colorScheme.secondary,
              ),
            ),
        ],
      ),
    );
  }
}
