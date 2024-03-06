import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'chat_room_view_model.dart'; // ViewModel import

class ChatRoomPage extends StatefulWidget {
  final String chatRoomId;

  const ChatRoomPage({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late final ChatRoomViewModel _viewModel;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = ChatRoomViewModel(widget.chatRoomId);
    _viewModel.fetchRoom();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<types.Room?>(
      stream: _viewModel.roomStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final room = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text(room.name ?? '채팅방'),
          ),
          body: Column(
            children: [
              Expanded(
                child: _buildMessageList(room),
              ),
              _buildMessageInput(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageList(types.Room room) {
    return StreamBuilder<List<types.Message>>(
      stream: FirebaseChatCore.instance.messages(room),
      initialData: const [],
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('메시지가 없습니다.'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          reverse: true,
          itemBuilder: (context, index) {
            final message = snapshot.data![index];
            return ListTile(
              title: Text(
                message.author.id == FirebaseChatCore.instance.firebaseUser?.uid
                    ? '나: ${message.toJson()['text']}'
                    : message.toJson()['text'],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(hintText: '메시지를 입력하세요...'),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    _viewModel.sendToMessage(text);
    _messageController.clear();
  }
}
