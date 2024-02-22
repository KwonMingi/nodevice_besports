import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nodevice/io/firebase_data_service.dart';
import 'package:nodevice/ui/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';
import 'chat_view_model.dart'; // ChatViewModel 클래스를 포함한 파일 임포트

class ChatScreen extends StatelessWidget {
  final String chatRoomId;
  final String chatRoomName;

  const ChatScreen(
      {super.key, required this.chatRoomId, required this.chatRoomName});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(chatRoomId, chatRoomName),
      child: Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(viewModel.chatRoom.chatRoomName),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.messages.length,
                    itemBuilder: (context, index) {
                      final message = viewModel.messages[index];
                      return ListTile(
                        title: Text(message.text),
                        subtitle: Text(
                            "From: ${message.senderId} - ${viewModel.formatTimestamp(message.timestamp)}"),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextEntryWidget(viewModel: viewModel),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TextEntryWidget extends StatefulWidget {
  final ChatViewModel viewModel;

  const TextEntryWidget({super.key, required this.viewModel});

  @override
  _TextEntryWidgetState createState() => _TextEntryWidgetState();
}

class _TextEntryWidgetState extends State<TextEntryWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Enter a message'),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              showLoadingDialog(context);
              widget.viewModel
                  .sendMessage(_controller.text, getCurrentUserId()!);
              Navigator.of(context).pop();
              _controller.clear();
            }
          },
        ),
      ],
    );
  }
}
