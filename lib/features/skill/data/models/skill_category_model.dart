import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/skill_category.dart';

class SkillCategoryModel extends SkillCategory {
  const SkillCategoryModel({
    required super.id,
    required super.userId,
    required super.key,
    required super.name,
    required super.icon,
    required super.color,
  });

  factory SkillCategoryModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return SkillCategoryModel(
      id: doc.id,
      userId: data['userId'] as String,
      key: data['key'] as String,
      name: data['name'] as String,
      icon: data['icon'] as String,
      color: data['color'] as String,
    );
  }

  factory SkillCategoryModel.fromEntity(SkillCategory entity) {
    return SkillCategoryModel(
      id: entity.id,
      userId: entity.userId,
      key: entity.key,
      name: entity.name,
      icon: entity.icon,
      color: entity.color,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'key': key,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }

  SkillCategory toEntity() => this;
}
