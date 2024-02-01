import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nodevice/constants/on_memory_data.dart';
import 'package:nodevice/io/firebase_data_service.dart';
import 'package:nodevice/utils/chat_util.dart';
import 'package:uuid/uuid.dart';

class CreateChatRoomScreen extends StatefulWidget {
  const CreateChatRoomScreen({super.key});

  @override
  State<CreateChatRoomScreen> createState() => _CreateChatRoomScreenState();
}

class _CreateChatRoomScreenState extends State<CreateChatRoomScreen> {
  final TextEditingController _uidController = TextEditingController();
  final TextEditingController _chatRoomNameController =
      TextEditingController(); // 채팅방 이름을 위한 컨트롤러 추가
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _uidController.dispose();
    _chatRoomNameController.dispose(); // 추가된 컨트롤러 dispose 처리
    super.dispose();
  }

  void _createChatRoom() async {
    String uid2 = _uidController.text.trim();
    String chatRoomName = _chatRoomNameController.text.trim(); // 채팅방 이름 가져오기
    if (uid2.isNotEmpty && chatRoomName.isNotEmpty) {
      // 채팅방 이름과 UID가 모두 입력되었는지 확인
      String currentUserId = getCurrentUserId()!;
      var uuid = const Uuid();
      String chatRoomId = uuid.v4(); // 랜덤한 고유 ID 생성
      String chatRoomName = _chatRoomNameController.text;

      // Firestore에 새 채팅방 생성
      DocumentReference chatRoomRef =
          firestore.collection('chatrooms').doc(chatRoomId);
      FieldValue user1TimeStamp = FieldValue.serverTimestamp();
      FieldValue user2TimeStamp = FieldValue.serverTimestamp();
      await chatRoomRef.set({
        'name': chatRoomName,
        'participants': [currentUserId, uid2],
        // 'lastRead': {
        //   currentUserId: user1TimeStamp,
        //   uid2: user2TimeStamp
        // }, // lastRead 초기화
      });

      // 채팅방 화면으로 네비게이션
      context.go('/chatroom/$chatRoomId');
    } else {
      // uid2가 비어있음: 에러 메시지 표시
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('User UID cannot be empty'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Chat Room')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _chatRoomNameController, // 채팅방 이름 입력 필드
              decoration: const InputDecoration(
                labelText: 'Enter Chat Room Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _uidController,
              decoration: const InputDecoration(
                labelText: 'Enter User UID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createChatRoom,
              child: const Text('Create Chat Room'),
            ),
          ],
        ),
      ),
    );
  }
}
