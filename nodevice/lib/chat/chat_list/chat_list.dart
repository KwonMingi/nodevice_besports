import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nodevice/chat/chat_list/chat_list_view_model.dart';
import 'package:nodevice/chat/chat_list/create_chat_room.dart';
import 'package:nodevice/constants/on_memory_data.dart';

final chatRoomsProvider = ChangeNotifierProvider((ref) => ChatRoomsViewModel());

class ChatRoomsScreen extends ConsumerWidget {
  const ChatRoomsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoomsViewModel = ref.watch(chatRoomsProvider);
    String currentUserId = ExerciseStatus.user.userID;

    return Scaffold(
      appBar: AppBar(title: const Text('Chat Rooms')),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: chatRoomsViewModel.chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = chatRoomsViewModel.chatRooms[index];
              if (chatRoom['participants'].contains(currentUserId)) {
                return ListTile(
                  title: Text(chatRoom['name'] ?? 'Chat Room'),
                  onTap: () {
                    context.go('/chatroom/${chatRoom.id}');
                  },
                );
              } else {
                return Container(); // 현재 사용자가 포함되지 않은 채팅방은 표시하지 않음
              }
            },
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateChatRoomScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
