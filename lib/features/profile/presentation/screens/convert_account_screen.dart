import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/router/route_names.dart';
import '../../../auth/domain/exceptions/auth_exceptions.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

/// Screen to convert a guest account to a permanent email/password account
class ConvertAccountScreen extends ConsumerStatefulWidget {
  const ConvertAccountScreen({super.key});

  @override
  ConsumerState<ConvertAccountScreen> createState() =>
      _ConvertAccountScreenState();
}

class _ConvertAccountScreenState extends ConsumerState<ConvertAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleConversion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final linkEmailPasswordUseCase = ref.read(
        linkEmailPasswordUseCaseProvider,
      );
      await linkEmailPasswordUseCase(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Force refresh of auth state to reflect that the user is no longer anonymous
      ref.invalidate(authStateProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).success)),
        );
        context.go(RouteNames.profile);
      }
    } catch (e) {
      if (mounted) {
        final localizations = AppLocalizations.of(context);
        String message;

        if (e is EmailAlreadyInUseException) {
          message = localizations.errorEmailAlreadyInUse;
        } else if (e is InvalidEmailException) {
          message = localizations.errorInvalidEmail;
        } else if (e is WeakPasswordException) {
          message = localizations.errorWeakPassword;
        } else if (e is AuthException) {
          message = e.message ?? localizations.errorGenericAuth;
        } else {
          message = e.toString();
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.convertAccountTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  localizations.convertAccountSubtitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  localizations.convertAccountInfo,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: localizations.emailLabel,
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.emailRequired;
                    }
                    if (!value.contains('@')) {
                      return localizations.invalidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: localizations.passwordLabel,
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.passwordRequired;
                    }
                    if (value.length < 6) {
                      return localizations.passwordTooShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: localizations.confirmPasswordLabel,
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.confirmPasswordRequired;
                    }
                    if (value != _passwordController.text) {
                      return localizations.passwordsDoNotMatch;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Convert Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleConversion,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(localizations.convertAccountButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
