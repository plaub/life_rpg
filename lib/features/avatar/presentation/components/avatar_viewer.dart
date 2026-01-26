import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../domain/entities/avatar_config.dart';

class AvatarViewer extends StatelessWidget {
  final AvatarConfig config;
  final double height;
  final bool autoRotate;

  const AvatarViewer({
    super.key,
    required this.config,
    this.height = 300,
    this.autoRotate = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ModelViewer(
        key: ValueKey(config.modelUrl),
        backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
        src: config.modelUrl,
        alt: "A 3D model of an avatar",
        ar: false,
        autoRotate: autoRotate,
        cameraControls: true,
        disableZoom: false,
        interactionPrompt: InteractionPrompt.auto,
      ),
    );
  }
}
