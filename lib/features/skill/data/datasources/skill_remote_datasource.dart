import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/skill_model.dart';
import '../models/skill_log_model.dart';
import '../models/skill_category_model.dart';

abstract class SkillRemoteDataSource {
  Stream<List<SkillModel>> getSkills(String userId);
  Future<SkillModel?> getSkill(String skillId);
  Future<void> saveSkill(SkillModel skill);
  Future<void> deleteSkill(String skillId);

  Stream<List<SkillCategoryModel>> getCategories(String userId);
  Future<void> saveCategory(SkillCategoryModel category);

  Future<List<SkillLogModel>> getLogsForSkill(
    String skillId,
    String userId, {
    int? limit,
  });
  Stream<List<SkillLogModel>> getLogsForSkillStream(
    String skillId,
    String userId, {
    int? limit,
  });
  Future<List<SkillLogModel>> getLogsForUser(String userId, {int? limit});
  Future<SkillLogModel?> getLog(String logId);
  Future<void> createLog(SkillLogModel log);
  Future<void> deleteLog(String logId);

  // Need method to fetch category by ref or id
  Future<SkillCategoryModel?> getCategory(DocumentReference ref);
  Future<SkillCategoryModel?> getCategoryById(String id);
  DocumentReference createCategoryRef(String id);
}

class SkillRemoteDataSourceImpl implements SkillRemoteDataSource {
  final FirebaseFirestore _firestore;

  SkillRemoteDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Collections
  CollectionReference<Map<String, dynamic>> get _skills =>
      _firestore.collection('skills');
  CollectionReference<Map<String, dynamic>> get _skillLogs =>
      _firestore.collection('skill_logs');
  CollectionReference<Map<String, dynamic>> get _skillCategories =>
      _firestore.collection('skill_categories');

  @override
  DocumentReference createCategoryRef(String id) {
    return _skillCategories.doc(id);
  }

  @override
  Stream<List<SkillModel>> getSkills(String userId) {
    return _skills.where('userId', isEqualTo: userId).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) => SkillModel.fromFirestore(doc)).toList();
    });
  }

  @override
  Future<SkillModel?> getSkill(String skillId) async {
    final doc = await _skills.doc(skillId).get();
    if (doc.exists) {
      return SkillModel.fromFirestore(doc);
    }
    return null;
  }

  @override
  Future<void> saveSkill(SkillModel skill) async {
    await _skills
        .doc(skill.id)
        .set(skill.toFirestore(), SetOptions(merge: true));
  }

  @override
  Future<void> deleteSkill(String skillId) async {
    await _skills.doc(skillId).delete();
  }

  @override
  Future<List<SkillLogModel>> getLogsForSkill(
    String skillId,
    String userId, {
    int? limit,
  }) async {
    Query<Map<String, dynamic>> query = _skillLogs
        .where('skillId', isEqualTo: skillId)
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => SkillLogModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<SkillLogModel>> getLogsForUser(
    String userId, {
    int? limit,
  }) async {
    Query<Map<String, dynamic>> query = _skillLogs
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => SkillLogModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<SkillLogModel?> getLog(String logId) async {
    final doc = await _skillLogs.doc(logId).get();
    if (doc.exists) {
      return SkillLogModel.fromFirestore(doc);
    }
    return null;
  }

  @override
  Future<void> createLog(SkillLogModel log) async {
    await _skillLogs.doc(log.id).set(log.toFirestore());
  }

  @override
  Future<void> deleteLog(String logId) async {
    await _skillLogs.doc(logId).delete();
  }

  @override
  Future<SkillCategoryModel?> getCategory(DocumentReference ref) async {
    final doc = await ref.get();
    if (doc.exists && doc.data() is Map<String, dynamic>) {
      // We have to cast safely because DocumentSnapshot is generic but usually holds Map<String,dynamic> if fetched via collection ref
      // But here ref might be generic.
      return SkillCategoryModel.fromFirestore(
        doc as DocumentSnapshot<Map<String, dynamic>>,
      );
    }
    return null;
  }

  @override
  Future<SkillCategoryModel?> getCategoryById(String id) async {
    final doc = await _skillCategories.doc(id).get();
    if (doc.exists) {
      return SkillCategoryModel.fromFirestore(doc);
    }
    return null;
  }

  @override
  Future<void> saveCategory(SkillCategoryModel category) async {
    await _skillCategories
        .doc(category.id)
        .set(category.toFirestore(), SetOptions(merge: true));
  }

  @override
  Stream<List<SkillCategoryModel>> getCategories(String userId) {
    return _skillCategories.where('userId', isEqualTo: userId).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => SkillCategoryModel.fromFirestore(doc))
          .toList();
    });
  }

  @override
  Stream<List<SkillLogModel>> getLogsForSkillStream(
    String skillId,
    String userId, {
    int? limit,
  }) {
    Query<Map<String, dynamic>> query = _skillLogs
        .where('skillId', isEqualTo: skillId)
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => SkillLogModel.fromFirestore(doc))
          .toList();
    });
  }
}
