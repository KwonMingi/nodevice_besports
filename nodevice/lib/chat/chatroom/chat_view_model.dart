import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:nodevice/chat/chat_data_struct.dart';
import 'package:nodevice/io/firebase_data_service.dart';

class ChatViewModel extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final ChatRoom chatRoom;
  List<Message> messages = [];
  int unreadMessagesCount = 0;

  ChatViewModel(String chatRoomId, String chatRoomName) {
    chatRoom =
        ChatRoom(chatRoomId: chatRoomId, chatRoomName: chatRoomName, users: []);
    loadMessages();
    updateLastRead();
    loadParticipants();
  }

  void loadParticipants() async {
    try {
      var chatRoomSnapshot = await firestore
          .collection('chatrooms')
          .doc(chatRoom.chatRoomId)
          .get();
      var data = chatRoomSnapshot.data();
      if (data != null && data['participants'] is List) {
        // List<dynamic>을 List<String>으로 안전하게 변환
        chatRoom.setUsers = List<String>.from(data['participants']);
      }
      notifyListeners();
    } catch (e) {
      // Handle errors
    }
  }

  Future<void> updateLastRead() async {
    try {
      String userId = getCurrentUserId()!;
      await firestore.collection('chatrooms').doc(chatRoom.chatRoomId).set({
        'lastRead': {userId: FieldValue.serverTimestamp()},
      }, SetOptions(merge: true));
    } catch (e) {
      // Handle errors
    }
  }

  void loadMessages() {
    firestore
        .collection('chatrooms')
        .doc(chatRoom.chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      unreadMessagesCount = 0;
      messages = snapshot.docs
          .map((doc) => Message(
                id: doc.id,
                text: doc.data()['message'],
                senderId: doc.data()['sender'],
                timestamp: doc.data()['timestamp'],
              ))
          .toList();
      notifyListeners();
    });
  }

  Future<void> sendMessage(String message, String userId) async {
    try {
      var data = {
        'message': message,
        'sender': userId,
        'timestamp': FieldValue.serverTimestamp(),
      };
      await firestore
          .collection('chatrooms')
          .doc(chatRoom.chatRoomId)
          .collection('messages')
          .add(data);
    } catch (e) {
      // Handle errors
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await firestore
          .collection('chatrooms')
          .doc(chatRoom.chatRoomId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      // Handle errors
    }
  }

  Future<void> leaveChatRoom(String userId) async {
    try {
      DocumentReference chatRoomRef =
          firestore.collection('chatrooms').doc(chatRoom.chatRoomId);
      DocumentSnapshot chatRoomSnapshot = await chatRoomRef.get();
      var data = chatRoomSnapshot.data() as Map<String, dynamic>?;
      List<dynamic> participants =
          data?['participants'] as List<dynamic>? ?? [];

      participants.remove(userId);

      await chatRoomRef.update({'participants': participants});
    } catch (e) {
      // Handle errors
    }
  }
}
