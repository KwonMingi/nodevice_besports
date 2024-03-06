import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:nodevice/io/firebase_data_service.dart';
import 'package:uuid/uuid.dart';

class CreateChatPage extends StatefulWidget {
  const CreateChatPage({super.key});

  @override
  State<CreateChatPage> createState() => _CreateChatPageState();
}

class _CreateChatPageState extends State<CreateChatPage> {
  final uid = getCurrentUserId();
  Future<types.User?> searchUserByFirstNameAndTag(
      String firstName, String tag) async {
    final firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('users_profile')
          .where('first_name', isEqualTo: firstName)
          .where('tag', isEqualTo: tag)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        types.User user = types.User(
          id: userDoc.id,
          firstName: userData['first_name'],
          lastName: userData['last_name'],
          imageUrl: userData['image_url'],
          // 추가 필드가 필요하면 여기에 포함시키세요
        );

        return user;
      } else {
        print('해당 조건에 맞는 사용자를 찾을 수 없습니다.');
        return null;
      }
    } catch (e) {
      print('사용자 정보 검색 실패: $e');
      return null;
    }
  }

  Future<void> createRoomAndAddInitialMessage(types.User otherUser) async {
    try {
      final room = await FirebaseChatCore.instance.createRoom(otherUser);

      final textMessage = types.TextMessage(
        author: types.User(id: uid ?? ''),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: '채팅방이 생성되었습니다.',
      );
      FirebaseChatCore.instance.sendMessage(textMessage, room.id);

      if (mounted) {
        context.push('/chatroom/${room.id}');
      }
    } catch (e) {
      print("채팅방 생성 또는 초기 메시지 추가 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("채팅"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("새 채팅방 생성"),
          onPressed: () async {
            String searchFirstName = "mingi";
            String searchTag = "KR1";

            final otherUser =
                await searchUserByFirstNameAndTag(searchFirstName, searchTag);

            if (otherUser != null) {
              await createRoomAndAddInitialMessage(otherUser);
            } else {
              print('검색된 사용자가 없어 채팅방을 생성할 수 없습니다.');
            }
          },
        ),
      ),
    );
  }
}
