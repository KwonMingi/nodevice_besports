import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nodevice/io/firebase_data_service.dart';

class ChatRoomsViewModel extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> chatRooms = [];
  String userId = getCurrentUserId()!; // 현재 사용자의 UID를 얻는 방법을 구현해야 합니다.

  ChatRoomsViewModel() {
    loadChatRooms();
  }

  void loadChatRooms() {
    firestore
        .collection('chatrooms')
        .where('participants',
            arrayContains: userId) // 'users' 필드에 userId가 포함된 문서만 필터링
        .snapshots()
        .listen((snapshot) {
      chatRooms = snapshot.docs;
      notifyListeners();
    });
  }
}
