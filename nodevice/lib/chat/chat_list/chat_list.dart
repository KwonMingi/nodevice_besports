import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nodevice/chat/chat_list/chat_list_view_model.dart';
import 'package:nodevice/chat/chatroom/chat.dart';
import 'package:nodevice/io/firebase_data_service.dart';

// Ensure this provider is defined somewhere in your codebase
final chatRoomsProvider = ChangeNotifierProvider((ref) {
  String? userId =
      getCurrentUserId(); // This function needs to be defined to fetch the current user's ID
  if (userId != null) {
    return ChatRoomsViewModel(userId);
  } else {
    throw Exception(
        'User ID is null'); // Handle the case where the user ID is not available
  }
});

class ChatRoomsScreen extends ConsumerWidget {
  const ChatRoomsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoomsViewModel = ref.watch(chatRoomsProvider);
    getCurrentUserId(); // Ensure this function is defined and accessible

    return Scaffold(
      appBar: AppBar(title: const Text('Chat Rooms')),
      body: ListView.builder(
        itemCount: chatRoomsViewModel.chatRooms.length,
        itemBuilder: (context, index) {
          final chatRoom = chatRoomsViewModel.chatRooms[index];

          // Use Flutter's built-in CircleAvatar widget
          final avatar = CircleAvatar(
            backgroundImage: NetworkImage(
                chatRoom.imageUrl ?? ''), // Fallback for 'imageUrl' if null
          );

          return ListTile(
            leading: avatar, // Display avatar next to room name
            title: Text(chatRoom.name ?? 'Chat Room'),
            subtitle: const Text(
                'Last message...'), // Display last message or other info
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(room: chatRoom)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/createChatRoom'); // Use GoRouter for navigation
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
