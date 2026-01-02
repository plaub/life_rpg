import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile_model.dart';

class ProfileRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProfileRemoteDataSource(this._firestore);

  CollectionReference<UserProfileModel> _usersRef() {
    return _firestore
        .collection('users')
        .withConverter(
          fromFirestore: UserProfileModel.fromFirestore,
          toFirestore: (model, _) => model.toFirestore(),
        );
  }

  Future<UserProfileModel?> getProfile(String userId) async {
    final doc = await _usersRef().doc(userId).get();
    return doc.data();
  }

  Future<void> saveProfile(UserProfileModel profile) async {
    await _usersRef().doc(profile.id).set(profile, SetOptions(merge: true));
  }

  Stream<UserProfileModel?> getProfileStream(String userId) {
    return _usersRef().doc(userId).snapshots().map((doc) => doc.data());
  }
}
