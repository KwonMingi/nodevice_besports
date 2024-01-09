import 'package:nodevice/data_struct/user.dart';
import 'package:nodevice/io/firebase_data_service.dart';

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
