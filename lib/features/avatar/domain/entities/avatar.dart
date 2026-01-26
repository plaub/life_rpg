class Avatar {
  final String id;
  final String userId;
  final String name;
  final String? bio;
  final String avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Avatar({
    required this.id,
    required this.userId,
    required this.name,
    this.bio,
    required this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Avatar copyWith({
    String? id,
    String? userId,
    String? name,
    String? bio,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Avatar(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
