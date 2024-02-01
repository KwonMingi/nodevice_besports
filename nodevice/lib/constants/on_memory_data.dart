import 'package:nodevice/data_struct/user.dart';
import 'package:nodevice/data_struct/user_profile.dart';
import 'package:nodevice/io/firebase_data_service.dart';
import 'package:nodevice/io/flutter_user_profile_service.dart';

class BoolStatus {
  static bool isModal = false;
  static bool isModalOpen = false;
}

class UID {
  static String uid = "";
}

class ExerciseStatus {
  static UserData user = UserData();

  static Future<void> loadUserData(String userID) async {
    FirestoreDataService firestoreService = FirestoreDataService();
    user = await firestoreService.getUserData(userID);
  }

  static Future<void> saveUserData() async {
    FirestoreDataService firestoreService = FirestoreDataService();
    await firestoreService.uploadUserData(user);
  }
}

class UserProfileOnMemory {
  static late UserProfile userProfile;

  static Future<void> loadUserProfile() async {
    String uid = getCurrentUserId()!;
    UserProfile? profile =
        await FirebaseUserProfileService().getUserProfile(uid);
    if (profile != null) {
      userProfile = profile;
    } else {
      // UserProfile이 존재하지 않는 경우의 처리 (예: 기본값 설정, 오류 처리 등)
    }
  }
}
