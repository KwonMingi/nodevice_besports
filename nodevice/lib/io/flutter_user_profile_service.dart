import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nodevice/data_struct/user_profile.dart';

class FirebaseUserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to save a UserProfile to Firestore
  Future<void> saveUserProfile(String uid, UserProfile profile) async {
    DocumentReference userDocRef = _firestore.collection('users').doc(uid);
    CollectionReference userProfileColRef =
        userDocRef.collection('user_profile');
    DocumentReference userProfileDocRef = userProfileColRef.doc('profile');

    await userProfileDocRef.set({
      'firstName': profile.firstName,
      'lastName': profile.lastName,
      'age': profile.age,
      'birthday': profile.birthday,
      'permission': profile.recordSharingPermissionAllowed,
      'centerUID': profile.centerID,
      'pt': profile.ptTrainerID,
      'nickName': profile.nickName, // 닉네임 필드 추가
      'tag': profile.tag, // 태그 필드 추가
    });
  }

  // Method to retrieve a UserProfile from Firestore
  Future<UserProfile?> getUserProfile(String uid) async {
    DocumentReference userProfileDocRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('user_profile')
        .doc('profile');

    DocumentSnapshot snapshot = await userProfileDocRef.get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return UserProfile(
        birthday: data['birthday'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        recordSharingPermissionAllowed: data['permission'],
        nickName: data['nickName'],
        centerID: data['centerID'],
        tag: data['tag'],
        ptTrainerID: data['pt'],
        // 여기에 추가적인 필드 처리를 추가할 수 있습니다.
      );
    } else {
      return null;
    }
  }
}
