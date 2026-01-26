class AvatarConfig {
  final String modelUrl;
  final Map<String, String> customizations;

  const AvatarConfig({required this.modelUrl, this.customizations = const {}});

  factory AvatarConfig.defaultConfig() {
    return const AvatarConfig(
      modelUrl: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
    );
  }

  factory AvatarConfig.fromJson(Map<String, dynamic> json) {
    return AvatarConfig(
      modelUrl:
          json['modelUrl'] as String? ??
          'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
      customizations: Map<String, String>.from(
        json['customizations'] as Map? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'modelUrl': modelUrl, 'customizations': customizations};
  }

  AvatarConfig copyWith({
    String? modelUrl,
    Map<String, String>? customizations,
  }) {
    return AvatarConfig(
      modelUrl: modelUrl ?? this.modelUrl,
      customizations: customizations ?? this.customizations,
    );
  }
}
