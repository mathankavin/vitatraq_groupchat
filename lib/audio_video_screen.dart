import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:cometchat_sdk/cometchat_sdk.dart';
import 'package:cometchat_sdk/handlers/call_listener.dart';
import 'package:cometchat_sdk/models/call.dart';
import 'package:flutter/material.dart';
import 'package:cometchat_calls_sdk/cometchat_calls_sdk.dart';
import 'package:vitatraq_chart/incoming_call_screen.dart';

class ChatScreenNew extends StatefulWidget {
  final String conversationWithName;
  final String conversationWithUid;
  final String conversationType;

  ChatScreenNew({
    required this.conversationWithName,
    required this.conversationWithUid,
    required this.conversationType,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenNew> {
 
 @override
void initState() {
  super.initState();
  CometChat.addCallListener(
    'ChatScreenNew_CallListener',
    CustomCallListener(context),
  );
}

@override
void dispose() {
  CometChat.removeCallListener('ChatScreenNew_CallListener');
  super.dispose();
}




  void _initiateAudioCall(String receiverUid) {
    var sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var call = Call(
      sessionId: sessionId,
      receiverUid: receiverUid,
      receiverType: widget.conversationType == 'user'
          ? ReceiverTypeConstants.user
          : ReceiverTypeConstants.group,
      type: 'audio',
    );

    CometChat.initiateCall(
      call,
      onSuccess: (Call initiatedCall) {
                print('initiatedCallinitiatedCall${initiatedCall}');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AudioCallScreen(call: initiatedCall),
          ),
        );
      },
      onError: (CometChatException error) {
        print('Audio Call failed: $error');
      },
    );
  }

  void _initiateVideoCall(String receiverUid) {
    var sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var call = Call(
      sessionId: sessionId,
      receiverUid: receiverUid,
      receiverType: widget.conversationType == 'user'
          ? ReceiverTypeConstants.user
          : ReceiverTypeConstants.group,
      type: 'video',
    );

    CometChat.initiateCall(
      call,
      onSuccess: (Call initiatedCall) {
        print('initiatedCallinitiatedCall${initiatedCall}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoCallScreen(call: initiatedCall),
          ),
        );
      },
      onError: (CometChatException error) {
        print('Video Call failed: $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversationWithName),
      ),
      body: Stack(
        children: [
          // CometChatMessages widget to display chat interface
          CometChatMessages(
            user: widget.conversationType == 'user'
                ? User(name: widget.conversationWithName, uid: widget.conversationWithUid)
                : null,
            group: widget.conversationType == 'group'
                ? Group(
                    guid: widget.conversationWithUid,
                    name: widget.conversationWithName,
                    type: 'public',
                  )
                : null,
          ),
          // Positioned widget to place the call buttons at the top-right corner
          Positioned(
            top: 5,
            right: 55,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.phone, color: Colors.blue),
                  onPressed: () {
                    // Handle audio call
                    print('Audio call button pressed');
                    _initiateAudioCall(widget.conversationWithUid);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.videocam, color: Colors.blue),
                  onPressed: () {
                    // Handle video call
                    print('Video call button pressed');
                    _initiateVideoCall(widget.conversationWithUid);
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

class AudioCallScreen extends StatelessWidget {
  final Call call;

  AudioCallScreen({required this.call});

  @override
  Widget build(BuildContext context) {

       String receiverName = 'Unknown';

    if (call.receiver is User) {
      receiverName = (call.receiver as User).name;
    } else if (call.receiver is Group) {
      receiverName = (call.receiver as Group).name;
    } else {
      print('nothing');
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Call'),
      ),
      body: Center(
        child: Text('In Audio Call with ${receiverName}'),
      ),
    );
  }
}

class VideoCallScreen extends StatelessWidget {
  final Call call;

  VideoCallScreen({required this.call});

  @override
  Widget build(BuildContext context) {
   String receiverName = 'Unknown';

    if (call.receiver is User) {
      receiverName = (call.receiver as User).name;
    } else if (call.receiver is Group) {
      receiverName = (call.receiver as Group).name;
    }  else {
      print('call.receiver${call}');
      print('nothing');
    }

    
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Call'),
      ),
      body: Center(
        child: Text('In Video Call with ${receiverName}'),
      ),
    );
  }
}



class CustomCallListener implements CallListener {
  final BuildContext context;

  CustomCallListener(this.context);

  @override
  void onIncomingCallReceived(Call call) {
    print('incoming call recived');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IncomingCallScreen(call: call),
      ),
    );
  }

  @override
  void onOutgoingCallAccepted(Call call) {
    // Handle outgoing call accepted
  }

  @override
  void onOutgoingCallRejected(Call call) {
    // Handle outgoing call rejected
  }

  @override
  void onIncomingCallCancelled(Call call) {
    // Handle incoming call cancelled
  }
  
  @override
  void onCallEndedMessageReceived(Call call) {
    // TODO: implement onCallEndedMessageReceived
  }
}
