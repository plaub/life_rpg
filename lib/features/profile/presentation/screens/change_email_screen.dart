import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../core/i18n/app_localizations.dart';

class ChangeEmailScreen extends ConsumerStatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  ConsumerState<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends ConsumerState<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();

  final _oldEmailController =
      TextEditingController(); // Just for display fallback
  final _newEmailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _oldEmailController.dispose();
    _newEmailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _updateEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final l10n = AppLocalizations.of(context);
        final authRepo = ref.read(authRepositoryProvider);

        // 1. Re-authenticate
        await authRepo.reauthenticateWithPassword(_passwordController.text);

        // 2. Update Auth Email
        await authRepo.updateEmail(_newEmailController.text.trim());

        // 3. Inform user about pending verification
        if (mounted) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(l10n.success),
              content: Text(l10n.emailVerificationPending),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.confirm),
                ),
              ],
            ),
          );
          if (mounted) context.pop();
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
    final user = ref.watch(currentUserProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.changeEmail)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l10n.currentEmailLabel}: ${user?.email ?? l10n.error}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _newEmailController,
                decoration: InputDecoration(
                  labelText: l10n.newEmailLabel,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    v == null || !v.contains('@') ? l10n.invalidEmail : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _confirmEmailController,
                decoration: InputDecoration(
                  labelText: l10n.confirmNewEmailLabel,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v != _newEmailController.text)
                    return l10n.emailsDoNotMatch;
                  return null;
                },
              ),
              const SizedBox(height: 24),

              Text(
                l10n.securityPasswordPrompt,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: l10n.passwordLabel,
                  border: const OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (v) =>
                    v == null || v.isEmpty ? l10n.passwordRequired : null,
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _isLoading ? null : _updateEmail,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(l10n.updateEmailButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
