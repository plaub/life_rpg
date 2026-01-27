import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../core/i18n/app_localizations.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final l10n = AppLocalizations.of(context);
        final authRepo = ref.read(authRepositoryProvider);

        // 1. Re-authenticate with old password
        await authRepo.reauthenticateWithPassword(_oldPasswordController.text);

        // 2. Update Password
        await authRepo.updatePassword(_newPasswordController.text);

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.passwordUpdatedSuccess)));
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
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.changePassword)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _oldPasswordController,
                decoration: InputDecoration(
                  labelText: l10n.currentPasswordLabel,
                  border: const OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (v) =>
                    v == null || v.isEmpty ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: l10n.newPasswordLabel,
                  border: const OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return l10n.fieldRequired;
                  if (v.length < 6) return l10n.passwordTooShort;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: l10n.confirmNewPasswordLabel,
                  border: const OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (v) {
                  if (v != _newPasswordController.text) {
                    return l10n.passwordsDoNotMatch;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _isLoading ? null : _updatePassword,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(l10n.updatePasswordButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
