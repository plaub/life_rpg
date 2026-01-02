import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../providers/profile_providers.dart';
import '../../domain/entities/user_profile.dart';

class EditProfileDetailsScreen extends ConsumerStatefulWidget {
  const EditProfileDetailsScreen({super.key});

  @override
  ConsumerState<EditProfileDetailsScreen> createState() =>
      _EditProfileDetailsScreenState();
}

class _EditProfileDetailsScreenState
    extends ConsumerState<EditProfileDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _bioController;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _initializeControllers(UserProfile? profile) {
    if (_isInitialized) return;
    if (profile != null) {
      _nameController.text = profile.displayName;
      _ageController.text = profile.age?.toString() ?? '';
      _bioController.text = profile.bio ?? '';
      _isInitialized = true;
    }
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      try {
        final l10n = AppLocalizations.of(context);
        await ref
            .read(profileControllerProvider.notifier)
            .updateProfile(
              displayName: _nameController.text.trim(),
              age: int.tryParse(_ageController.text.trim()),
              bio: _bioController.text.trim(),
            );

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.profileUpdatedSuccess)));
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.error}: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final state = ref.watch(profileControllerProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editProfileDetails)),
      body: profileAsync.when(
        data: (profile) {
          _initializeControllers(profile);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.displayNameLabel,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? l10n.nameRequired : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      labelText: l10n.ageOptionalLabel,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _bioController,
                    decoration: InputDecoration(
                      labelText: l10n.bioOptionalLabel,
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: state.isLoading ? null : _save,
                      child: state.isLoading
                          ? const CircularProgressIndicator()
                          : Text(l10n.save),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('${l10n.error}: $err')),
      ),
    );
  }
}
