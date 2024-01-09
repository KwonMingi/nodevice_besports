import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nodevice/data_struct/user_profile.dart';

class FirebaseUserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to save a UserProfile to Firestore
  Future<void> saveUserProfile(UserProfile profile) async {
    DocumentReference ref =
        _firestore.collection('user_profiles').doc(profile.uid);

    await ref.set({
      'uid': profile.uid,
      'firstName': profile.firstName,
      'lastName': profile.lastName,
      'age': profile.age,
      'birthday': profile.birthday,
      'permission': profile.permission,
      'centerUID': profile.senterUID,
    });
  }

  // Method to retrieve a UserProfile from Firestore
  Future<UserProfile?> getUserProfile(String uid) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('user_profiles').doc(uid).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return UserProfile(
        birthday: data['birthday'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        permission: data['permission'],
      );
    } else {
      return null;
    }
  }
}
