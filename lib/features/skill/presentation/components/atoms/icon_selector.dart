import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

/// Slack-inspired emoji/icon selector using emoji_picker_flutter
class IconSelector extends StatelessWidget {
  final String selectedIcon;
  final ValueChanged<String> onIconSelected;
  final bool showPreview;
  final double? maxHeight;

  const IconSelector({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
    this.showPreview = true,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight ?? 400),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Preview header
          if (showPreview)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        selectedIcon,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Wähle ein Icon',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Emoji picker
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: showPreview ? Radius.zero : const Radius.circular(16),
                bottom: const Radius.circular(16),
              ),
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  onIconSelected(emoji.emoji);
                },
                config: Config(
                  height: maxHeight ?? 280,
                  checkPlatformCompatibility: true,
                  emojiViewConfig: EmojiViewConfig(
                    columns: 7,
                    emojiSizeMax: 28,
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    gridPadding: const EdgeInsets.symmetric(horizontal: 8),
                    backgroundColor: colorScheme.surfaceContainer,
                    noRecents: const Text(
                      'Keine kürzlich verwendeten Emojis',
                      style: TextStyle(fontSize: 14),
                    ),
                    buttonMode: ButtonMode.CUPERTINO,
                    loadingIndicator: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  categoryViewConfig: CategoryViewConfig(
                    initCategory: Category.SMILEYS,
                    backgroundColor: colorScheme.surface,
                    indicatorColor: colorScheme.primary,
                    iconColorSelected: colorScheme.primary,
                    iconColor: colorScheme.onSurfaceVariant,
                    tabBarHeight: 46,
                    categoryIcons: const CategoryIcons(),
                  ),
                  bottomActionBarConfig: BottomActionBarConfig(
                    showSearchViewButton: false,
                    enabled: true,
                    backgroundColor: colorScheme.surface,
                    buttonColor: colorScheme.primary,
                    buttonIconColor: colorScheme.onPrimary,
                  ),
                  searchViewConfig: SearchViewConfig(
                    backgroundColor: colorScheme.surface,
                    buttonIconColor: colorScheme.onSurfaceVariant,
                    hintText: 'Suche Emoji...',
                  ),
                  skinToneConfig: SkinToneConfig(
                    enabled: true,
                    dialogBackgroundColor: colorScheme.surfaceContainerHigh,
                    indicatorColor: colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
