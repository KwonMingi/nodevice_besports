import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nodevice/chat/chat_data_struct.dart';
import 'package:nodevice/chat/chatroom/chat_view_model.dart';
import 'package:nodevice/constants/static_status.dart';

final chatViewModelProvider =
    ChangeNotifierProvider.family<ChatViewModel, ChatRoom>(
  (ref, chatRoom) => ChatViewModel(chatRoom.chatRoomId, chatRoom.chatRoomName),
);

class ChatScreen extends ConsumerStatefulWidget {
  final String chatRoomId;
  final String chatRoomName;

  const ChatScreen(
      {Key? key, required this.chatRoomId, required this.chatRoomName})
      : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends ConsumerState<ChatScreen> {
  late final TextEditingController messageController;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String message, WidgetRef ref) {
    if (message.isNotEmpty) {
      final chatRoom = ChatRoom(
          chatRoomId: widget.chatRoomId,
          chatRoomName: widget.chatRoomName,
          users: []);
      ref
          .read(chatViewModelProvider(chatRoom))
          .sendMessage(message, ExerciseStatus.user.userID);
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatRoom = ChatRoom(
        chatRoomId: widget.chatRoomId,
        chatRoomName: widget.chatRoomName,
        users: []);
    final chatViewModel = ref.watch(chatViewModelProvider(chatRoom));

    ref.listen<List<Message>>(
      chatViewModelProvider(chatRoom).select((model) => model.messages),
      (_, __) =>
          scrollController.jumpTo(scrollController.position.maxScrollExtent),
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.chatRoomName)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              reverse: true,
              itemCount: chatViewModel.messages.length,
              itemBuilder: (context, index) {
                final message = chatViewModel
                    .messages[chatViewModel.messages.length - 1 - index];
                return ListTile(
                  title: Text(message.text),
                  trailing: message.senderId == ExerciseStatus.user.userID
                      ? const Icon(Icons.person)
                      : null,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration:
                        const InputDecoration(labelText: 'Enter message'),
                    onSubmitted: (value) => _sendMessage(value, ref),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(messageController.text, ref),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
