import 'skill_category.dart';

class Skill {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final SkillCategory category;
  final String icon;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Skill({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.category,
    required this.icon,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  Skill copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    SkillCategory? category,
    String? icon,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Skill(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
