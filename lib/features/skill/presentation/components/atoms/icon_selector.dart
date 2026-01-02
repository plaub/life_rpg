import 'package:flutter/material.dart';

class EmojiLibrary {
  static const Map<String, List<String>> categories = {
    'Activities': [
      '🚀',
      '💪',
      '🏃',
      '🧘',
      '🧗',
      '🚴',
      '🏊',
      '💃',
      '🏀',
      '⚽',
      '🎾',
      '🥊',
      '🎮',
      '🎯',
      '🎳',
      '⛳',
      '🛹',
      '🛶',
      '🚵',
    ],
    'Creative & Skills': [
      '🧠',
      '🎨',
      '🍳',
      '🎸',
      '💻',
      '📚',
      '🌱',
      '🛠️',
      '🔬',
      '🔭',
      '🎹',
      '🎷',
      '🎤',
      '🎬',
      '✍️',
      '🧶',
      '🧵',
      '🎭',
      '🔨',
      '📐',
    ],
    'Work & Finance': [
      '💰',
      '💼',
      '📈',
      '📊',
      '🏦',
      '💹',
      '💳',
      '💵',
      '🏧',
      '💻',
      '💾',
      '⌨️',
      '🖱️',
      '📁',
      '📄',
      '🖋️',
      '📅',
      '📌',
    ],
    'Nature & Animals': [
      '🐶',
      '🐱',
      '🦊',
      '🐻',
      '🐼',
      '🐨',
      '🐯',
      '🦁',
      '🐮',
      '🐷',
      '🐸',
      '🐵',
      '🐔',
      '🐧',
      '🐦',
      '🐝',
      '🦋',
      '🐘',
      '🐺',
      '🦉',
    ],
    'Food & Health': [
      '🍎',
      '🍕',
      '🍰',
      '☕',
      '🍺',
      '🥦',
      '🍣',
      '🥗',
      '🥑',
      '🥩',
      '🍔',
      '🍦',
      '🍩',
      '🥤',
      '🍷',
      '💊',
      '🏥',
      '🦷',
      '🩺',
    ],
    'Places & Travel': [
      '🏠',
      '🏢',
      '🏫',
      '🏥',
      '🏦',
      '🏨',
      '🏪',
      '🏛️',
      '⛪',
      '🕌',
      '🕍',
      '🕋',
      '⛲',
      '⛺',
      '🚂',
      '🚗',
      '🚲',
      '✈️',
      '🌍',
    ],
    'Objects & Symbols': [
      '💎',
      '🎁',
      '🎈',
      '📷',
      '📱',
      '⌚',
      '🎙️',
      '🎧',
      '🔋',
      '💡',
      '🔦',
      '📕',
      '🛡️',
      '⚔️',
      '🗝️',
      '⭐',
      '🔥',
      '⚡',
      '✨',
      '🏆',
      '🎖️',
    ],
  };

  static String getCategoryForEmoji(String emoji) {
    for (final entry in categories.entries) {
      if (entry.value.contains(emoji)) return entry.key;
    }
    return categories.keys.first;
  }
}

class IconSelector extends StatefulWidget {
  final String selectedIcon;
  final ValueChanged<String> onIconSelected;

  const IconSelector({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  @override
  State<IconSelector> createState() => _IconSelectorState();
}

class _IconSelectorState extends State<IconSelector> {
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = EmojiLibrary.getCategoryForEmoji(widget.selectedIcon);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icons = EmojiLibrary.categories[_selectedCategory] ?? [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _selectedCategory,
          isExpanded: true,
          decoration: InputDecoration(
            labelStyle: const TextStyle(fontSize: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            prefixIcon: const Icon(Icons.category_outlined, size: 20),
          ),
          items: EmojiLibrary.categories.keys.map((cat) {
            return DropdownMenuItem(
              value: cat,
              child: Text(cat, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedCategory = val);
            }
          },
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.05),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: GridView.builder(
            key: ValueKey(_selectedCategory),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 60,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: icons.length,
            itemBuilder: (context, index) {
              final icon = icons[index];
              final isSelected = widget.selectedIcon == icon;
              return InkWell(
                onTap: () => widget.onIconSelected(icon),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(color: theme.colorScheme.primary, width: 2)
                        : Border.all(color: Colors.transparent, width: 2),
                  ),
                  child: Text(icon, style: const TextStyle(fontSize: 24)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
