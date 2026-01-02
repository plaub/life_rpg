import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/skill.dart';
import '../../domain/entities/skill_category.dart';

class SkillModel {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final DocumentReference
  categoryRef; // Reference to 'skill_categories' collection
  final String icon;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SkillModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.categoryRef,
    required this.icon,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SkillModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return SkillModel(
      id: doc.id,
      userId: data['userId'] as String,
      name: data['name'] as String,
      description: data['description'] as String?,
      categoryRef: data['category'] as DocumentReference,
      icon: data['icon'] as String,
      isActive: data['isActive'] as bool,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      if (description != null) 'description': description,
      'category': categoryRef,
      'icon': icon,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Converts this DTO to a Domain Entity, requiring the joined Category.
  Skill toEntity(SkillCategory category) {
    if (categoryRef.id != category.id) {
      // Warning: mismatch potential. But mostly we just assume the caller resolved correctly.
    }
    return Skill(
      id: id,
      userId: userId,
      name: name,
      description: description,
      category: category,
      icon: icon,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
