import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:vitatraq_chart/AddMemberScreen.dart';
import 'package:vitatraq_chart/CustomCometChatDetails.dart';
import 'package:vitatraq_chart/SendMessageToAllScreen.dart';
import 'package:vitatraq_chart/chat_screen.dart';
import 'package:cometchat_calls_sdk/cometchat_calls_sdk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<BaseMessage> _messages = [];
  String currentUserName = '';
  final String currentUserId = "cometchat-uid-1"; // Replace with sender's ID
  final String receiverUid = "cometchat-uid-2"; // Replace with receiver's ID
  String userProfilePhotoUrl = '';
  bool isCompleted = false;
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _initializeCometChat();
  }

  @override
  void dispose() {
    super.dispose();
  }

    // UIKitSettings uiKitSettings = (UIKitSettingsBuilder()
    //       ..subscriptionType = CometChatSubscriptionType.allUsers
    //       ..autoEstablishSocketConnection = true
    //       ..region = "in" //Replace with your App Region
    //       ..appId = "2690788d14860d90" //Replace with your App ID
    //       ..authKey =
    //           "f0fb32ecb41defeed65843fa3ba8092f9bd0d7d1" //Replace with your app Auth Key
    //       ..extensions = CometChatUIKitChatExtensions
    //           .getDefaultExtensions()
    //     // ..callingExtension = CometChatUIKitChatExtensions.getDefaultExtensions().call()// Corrected method to enable calling feature // Enable calling feature //Replace this with empty array you want to disable all extensions
    //     )
    //     .build();

  void _initializeCometChat() {
    UIKitSettings uiKitSettings = (UIKitSettingsBuilder()
          ..subscriptionType = CometChatSubscriptionType.allUsers
          ..autoEstablishSocketConnection = true
          ..region = "in" //Replace with your App Region
          ..appId = "2690788d14860d90" //Replace with your App ID
          ..authKey =
              "f0fb32ecb41defeed65843fa3ba8092f9bd0d7d1" //Replace with your app Auth Key
          ..extensions = CometChatUIKitChatExtensions
              .getDefaultExtensions() //Replace this with empty array you want to disable all extensions
        )
        .build();

    CometChatUIKit.init(
        uiKitSettings: uiKitSettings,
        onSuccess: (successMessage) {
          // TODO("Not yet implemented")
          loginUser();
        },
        onError: (e) {
          // TODO("Not yet implemented")
        });
  }

//Group Chat CometChatConversations
  void loginUser() {
 
    CometChatUIKit.login(currentUserId, onSuccess: (s) {
      CometChat.getGroup("cometchat-guid-1",
              onSuccess: (Group retGrou) {},
              onError: (CometChatException excep) {})
          .then((group) {
        int membersCount = group?.membersCount ?? 0;
        print("Members Count: $membersCount");
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => 
          
        CreateGroupScreen()
        ),
      );

    }, onError: (e) {
      // TODO("Not yet implemented")
    });
  }

  void fetchChatHistory() {
    MessagesRequest messagesRequest = (MessagesRequestBuilder()
          ..uid = receiverUid
          ..limit = 50)
        .build();

    messagesRequest.fetchPrevious(onSuccess: (List<BaseMessage> messages) {
      setState(() {
        _messages.addAll(messages);
      });
    }, onError: (CometChatException excep) {
      print("Fetching chat history failed with exception: ${excep.message}");
    });
  }

  void _sendMessage() {
    String text = _controller.text.trim();
    if (text.isNotEmpty) {
      TextMessage message = TextMessage(
        receiverUid: receiverUid,
        text: text,
        receiverType: 'user',
        type: 'text',
      );
      CometChat.sendMessage(message, onSuccess: (msg) {
        setState(() {
          _messages.add(msg);
          _controller.clear();
        });
      }, onError: (CometChatException excep) {
        print("Message sending failed with exception: ${excep.message}");
      });
    }
  }

  void _sendMediaMessage(String filePath, String fileName) {
    MediaMessage message = MediaMessage(
      receiverUid: receiverUid,
      type: 'image',
      file: filePath,
      receiverType: 'user',
    );
    CometChat.sendMediaMessage(message, onSuccess: (msg) {
      setState(() {
        _messages.add(msg);
      });
    }, onError: (CometChatException excep) {
      print("Media message sending failed with exception: ${excep.message}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isCompleted
            ? Center(child: CircularProgressIndicator())
            : Container());
  }
}
