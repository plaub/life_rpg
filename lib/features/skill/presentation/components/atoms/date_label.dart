import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateLabel extends StatelessWidget {
  final DateTime date;
  final bool showTime;

  const DateLabel({
    super.key,
    required this.date,
    this.showTime = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // TODO: Use locale from provider if needed, but standard DateFormat often defaults to system
    final formatter = showTime ? DateFormat.yMMMd().add_jm() : DateFormat.yMMMd();

    return Text(
      formatter.format(date),
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
