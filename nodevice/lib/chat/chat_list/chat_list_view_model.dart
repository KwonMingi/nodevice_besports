import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomsViewModel extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> chatRooms = [];

  ChatRoomsViewModel() {
    loadChatRooms();
  }

  void loadChatRooms() {
    firestore.collection('chatrooms').snapshots().listen((snapshot) {
      chatRooms = snapshot.docs;
      notifyListeners();
    });
  }
}
