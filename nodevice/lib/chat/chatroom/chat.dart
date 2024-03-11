import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:nodevice/constants/custom_colors.dart';
import 'package:nodevice/data_struct/firebase_data_manages/user_firebase_manager.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.room,
  });

  final types.Room room;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  bool _isAttachmentUploading = false;

  final UserService _user = UserService();

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path!;
      final file = File(filePath);

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        FirebaseChatCore.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final updatedMessage = message.copyWith(isLoading: true);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final updatedMessage = message.copyWith(isLoading: false);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseChatCore.instance.firebaseUser; // 현재 사용자 가져오기

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: CustomColors.appGray,
              child: StreamBuilder<List<types.Message>>(
                stream: FirebaseChatCore.instance.messages(widget.room),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!;
                  return ListView.builder(
                    itemCount: messages.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isCurrentUser =
                          message.author.id == currentUser?.uid;

                      // 현재 사용자가 보낸 메시지
                      if (isCurrentUser) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.end, // 메시지 오른쪽 정렬
                            children: [
                              Card(
                                color: Theme.of(context).canvasColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: message is types.TextMessage
                                      ? Text(message.text,
                                          style: const TextStyle(
                                              color: Colors.black))
                                      : message is types.ImageMessage
                                          ? Image.network(message.uri,
                                              width: 200,
                                              height: 200,
                                              fit: BoxFit.cover)
                                          : const SizedBox.shrink(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // 다른 사용자가 보낸 메시지
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<String?>(
                              future: UserService()
                                  .getUserProfileImageUrl(message.author.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.data != null) {
                                  return CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(snapshot.data!),
                                    radius: 20,
                                  );
                                } else {
                                  return const CircleAvatar(
                                      radius: 20, child: Icon(Icons.person));
                                }
                              },
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder<String?>(
                                    future: UserService()
                                        .getUserFirstName(message.author.id),
                                    builder: (context, nameSnapshot) {
                                      if (nameSnapshot.connectionState ==
                                          ConnectionState.done) {
                                        return Text(
                                          nameSnapshot.data ?? 'Unknown User',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .canvasColor),
                                        );
                                      } else {
                                        return const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator());
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 5),
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: message is types.TextMessage
                                          ? Text(message.text)
                                          : message is types.ImageMessage
                                              ? Image.network(message.uri,
                                                  width: 200,
                                                  height: 200,
                                                  fit: BoxFit.cover)
                                              : const SizedBox.shrink(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return SafeArea(
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.photo),
            onPressed:
                _handleAtachmentPressed, // Implement this function to handle attachment
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: "Type a message",
              ),
              onSubmitted:
                  _handleSendPressed, // Update to use the correct function
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSendPressed(_textController.text),
          ),
        ],
      ),
    );
  }

  void _handleSendPressed(String text) {
    if (text.trim().isEmpty) return;

    final message = types.PartialText(
      text: text.trim(),
    );

    FirebaseChatCore.instance.sendMessage(message, widget.room.id);
    _textController.clear();
  }
}
