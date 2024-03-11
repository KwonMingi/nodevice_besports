import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getUserFirstName(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users_profile').doc(uid).get();
      if (userDoc.exists) {
        // `data()` 메서드의 반환 값을 명시적으로 캐스팅합니다.
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        // 이제 'first_name' 필드에 안전하게 접근할 수 있습니다.
        return userData['first_name'];
      } else {
        // 사용자 문서가 존재하지 않는 경우
        print('No user found for this uid');
        return null;
      }
    } catch (e) {
      // 에러 처리
      print(e);
      return null;
    }
  }

  Future<String?> getUserLastName(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users_profile').doc(uid).get();
      if (userDoc.exists) {
        // `data()` 메서드의 반환 값을 명시적으로 캐스팅합니다.
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        // 이제 'first_name' 필드에 안전하게 접근할 수 있습니다.
        return userData['last_name'];
      } else {
        // 사용자 문서가 존재하지 않는 경우
        print('No user found for this uid');
        return null;
      }
    } catch (e) {
      // 에러 처리
      print(e);
      return null;
    }
  }

  Future<String?> getUserProfileImageUrl(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users_profile').doc(userId).get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        // 'profileImageUrl' 필드에서 프로필 이미지 URL을 가져옵니다.
        String? profileImageUrl = userData?['profileImageUrl'];

        return profileImageUrl; // 프로필 이미지 URL을 반환합니다.
      }
      return null; // 사용자 문서가 없는 경우
    } catch (e) {
      print("Error getting user profile image URL: $e");
      return null; // 오류가 발생한 경우
    }
  }
}
