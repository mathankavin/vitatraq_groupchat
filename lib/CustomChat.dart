import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/material.dart';
  

class CustomChatScreen extends StatefulWidget {
  @override
  _CustomChatScreenState createState() => _CustomChatScreenState();
}

class _CustomChatScreenState extends State<CustomChatScreen> {
  @override
  void initState() {
    super.initState();
     addCallListener();
  }

 

  void addCallListener() {
    // CometChat.addCallListener(
    //   'callListener',
    //   CometChatCallListener(
    //     onIncomingCallReceived: (call) {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => CometChatCallingComponent(call: call),
    //         ),
    //       );
    //     },
    //     onOutgoingCallAccepted: (call) {
    //       // Handle outgoing call accepted
    //     },
    //     onOutgoingCallRejected: (call) {
    //       // Handle outgoing call rejected
    //     },
    //     onIncomingCallCancelled: (call) {
    //       // Handle incoming call cancelled
    //     },
    //   ),
    // );
  }

  void makeCall(String receiverID, String callType) {
    // CometChat.initiateCall(
    //   receiverID: receiverID,
    //   receiverType: 'user', // or 'group' if calling a group
    //   callType: callType, // 'audio' or 'video'
    //   onSuccess: (call) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => CometChatCallingComponent(call: call),
    //       ),
    //     );
    //   },
    //   onError: (error) {
    //     print('Call initiation failed: $error');
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              // Handle audio call
              print('Audio call button pressed');
            },
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              // Handle video call
              print('Video call button pressed');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          CometChatConversationsWithMessages(),
          Positioned(
            top: 0,
            right: 0,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: () {
                    // Handle audio call
                    print('Audio call button pressed');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.videocam),
                  onPressed: () {
                    // Handle video call
                    print('Video call button pressed');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
