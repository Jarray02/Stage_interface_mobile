import 'dart:convert';
import 'dart:math';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:first_flutter_project/Custm_Widgets/custm_widgets.dart';
import 'package:first_flutter_project/Services/storage_service.dart';
import 'package:first_flutter_project/models/message_data.dart';
import 'package:first_flutter_project/theme.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import '../../helpers.dart';
import 'messages.dart';

// For the testing purposes, you should probably use https://pub.dev/packages/uuid
String randomString() {
  var random = Random.secure();
  var values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class MessagingService extends StatelessWidget {
  static Route route(MessageData data, String userPic) => MaterialPageRoute(
      builder: (context) => MessagingService(
            messageData: data,
            userPic: userPic,
          ));
  final MessageData messageData;
  final String userPic;

  const MessagingService(
      {Key? key, required this.messageData, required this.userPic})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      home: MyMessagingService(userPic: userPic),
    );
  }
}

class MyMessagingService extends StatefulWidget {
  const MyMessagingService({Key? key, required this.userPic}) : super(key: key);

  final String userPic;

  @override
  _MyMessagingServiceState createState() => _MyMessagingServiceState();
}

class _MyMessagingServiceState extends State<MyMessagingService> {
  final storage = Storage();
  final List<types.Message> _messages = [];
  final _user = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
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
        );
      },
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final finalfile = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(finalfile);
      FirebaseChatCore.instance
          .sendMessage(finalfile, 'TODO : // Add the room ID');
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final finalimage = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: randomString(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(finalimage);
      FirebaseChatCore.instance
          .sendMessage(finalimage, 'TODO: // Add the room ID');
    }
  }

  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messages[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
    await _ref.child('ChatMessages').set({
      "author": _auth.currentUser!.uid,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "id": randomString(),
      "text": message.text
    });
  }

  @override
  Widget build(BuildContext context) {
    final Faker faker = Faker();
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        MessagesPage(userPic: widget.userPic)));
              },
              icon: const Icon(Icons.arrow_back)),
          title: Text(faker.person.name()),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Avatar.small(
                url: Helpers.randomPictureUrl(),
                onTap: () {},
              ),
            )
          ],
        ),
        body: Chat(
          messages: _messages,
          onAttachmentPressed: _handleAtachmentPressed,
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          user: _user,
          showUserAvatars: true,
        ),
      ),
    );
  }
}
