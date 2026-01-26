import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../domain/entities/avatar_config.dart';
import '../components/avatar_viewer.dart';

class AvatarBuilderScreen extends ConsumerStatefulWidget {
  const AvatarBuilderScreen({super.key});

  @override
  ConsumerState<AvatarBuilderScreen> createState() =>
      _AvatarBuilderScreenState();
}

class _AvatarBuilderScreenState extends ConsumerState<AvatarBuilderScreen> {
  late AvatarConfig _currentConfig;
  bool _isSaving = false;

  final List<Map<String, String>> _availableModels = [
    {
      'name': 'Astronaut',
      'url': 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
    },
    {
      'name': 'Robot',
      'url': 'https://modelviewer.dev/shared-assets/models/RobotExpressive.glb',
    },
    {
      'name': 'Duck',
      'url':
          'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/Duck/glTF-Binary/Duck.glb',
    },
    {
      'name': 'Chair',
      'url':
          'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/SheenChair/glTF-Binary/SheenChair.glb',
    },
  ];

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider).value;
    _currentConfig = profile?.avatarConfig ?? AvatarConfig.defaultConfig();
  }

  Future<void> _saveAvatar() async {
    setState(() => _isSaving = true);
    try {
      final profile = ref.read(userProfileProvider).value;
      if (profile != null) {
        final updatedProfile = profile.copyWith(avatarConfig: _currentConfig);
        await ref.read(profileRepositoryProvider).saveProfile(updatedProfile);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Avatar saved successfully!')),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving avatar: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Avatar'),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(icon: const Icon(Icons.check), onPressed: _saveAvatar),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.3),
              child: AvatarViewer(
                config: _currentConfig,
                height: double.infinity,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Base Model',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _availableModels.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final model = _availableModels[index];
                        final isSelected =
                            _currentConfig.modelUrl == model['url'];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentConfig = _currentConfig.copyWith(
                                modelUrl: model['url']!,
                              );
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 100,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer
                                  : Theme.of(
                                      context,
                                    ).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                model['name']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSelected
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer
                                      : Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
