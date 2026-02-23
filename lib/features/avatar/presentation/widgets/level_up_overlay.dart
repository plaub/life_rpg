import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:life_rpg/core/i18n/app_localizations.dart';
import 'package:life_rpg/core/theme/app_colors.dart';

class LevelUpOverlay extends StatefulWidget {
  final int newLevel;
  final String? skillName;
  final VoidCallback onClose;

  const LevelUpOverlay({
    super.key,
    required this.newLevel,
    this.skillName,
    required this.onClose,
  });

  @override
  State<LevelUpOverlay> createState() => _LevelUpOverlayState();

  static void show(BuildContext context, int newLevel, {String? skillName}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LevelUpOverlay(
        newLevel: newLevel,
        skillName: skillName,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class _LevelUpOverlayState extends State<LevelUpOverlay> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isSkill = widget.skillName != null;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.75),
      body: Stack(
        children: [
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
              shouldLoop: false,
              colors: [
                AppColors.xpGold,
                AppColors.levelPurple,
                AppColors.successGreen,
                AppColors.lightPrimary,
                AppColors.lightSecondary,
                AppColors.darkPrimary,
              ],
            ),
          ),

          // Content
          Center(
            child: Container(
              margin: const EdgeInsets.all(32),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: isDark
                      ? AppColors.xpGold.withValues(alpha: 0.2)
                      : theme.colorScheme.outlineVariant,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.xpGold.withValues(alpha: 0.25),
                    blurRadius: 40,
                    spreadRadius: 2,
                  ),
                  if (isDark)
                    BoxShadow(
                      color: AppColors.levelPurple.withValues(alpha: 0.15),
                      blurRadius: 60,
                      spreadRadius: 5,
                    ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isSkill ? '⭐' : '🎉',
                    style: const TextStyle(fontSize: 64),
                  ),
                  const SizedBox(height: 20),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [AppColors.xpGold, AppColors.levelPurple],
                    ).createShader(bounds),
                    child: Text(
                      isSkill ? l10n.skillUpTitle : l10n.levelUpTitle,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Required for ShaderMask
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isSkill
                        ? l10n.skillUpMessage(
                            widget.skillName!,
                            widget.newLevel,
                          )
                        : l10n.levelUpMessage(widget.newLevel),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isSkill ? l10n.skillUpSuccessBody : l10n.levelUpSuccessBody,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: widget.onClose,
                    child: Text(l10n.continueButton),
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
