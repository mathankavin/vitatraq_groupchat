import 'package:cometchat_sdk/exception/cometchat_exception.dart';
import 'package:cometchat_sdk/main/cometchat.dart';
import 'package:cometchat_sdk/models/call.dart';
import 'package:cometchat_sdk/models/group.dart';
import 'package:cometchat_sdk/models/user.dart';
import 'package:cometchat_sdk/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:cometchat_calls_sdk/cometchat_calls_sdk.dart';

class IncomingCallScreen extends StatelessWidget {
  final Call call;

  IncomingCallScreen({required this.call});

  void _acceptCall(BuildContext context) {
    CometChat.acceptCall(call.sessionId.toString(), onSuccess: (acceptedCall) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ActiveCallScreen(call: acceptedCall),
        ),
      );
    }, onError: (CometChatException error) {
      print('Accept call failed: $error');
    });
  }

  void _rejectCall() {
    CometChat.rejectCall(call.sessionId.toString(), CometChatCallStatus.rejected, onSuccess: (rejectedCall) {
      // Handle call rejection success
    }, onError: (CometChatException error) {
      print('Reject call failed: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    String receiverName = 'Unknown';

    if (call.receiver is User) {
      receiverName = (call.receiver as User).name;
    } else if (call.receiver is Group) {
      receiverName = (call.receiver as Group).name;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Incoming Call from $receiverName'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Incoming ${call.type} call from $receiverName'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _acceptCall(context),
                  child: Text('Accept'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _rejectCall,
                  child: Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ActiveCallScreen extends StatelessWidget {
  final Call call;

  ActiveCallScreen({required this.call});

  @override
  Widget build(BuildContext context) {
    String receiverName = 'Unknown';

    if (call.receiver is User) {
      receiverName = (call.receiver as User).name;
    } else if (call.receiver is Group) {
      receiverName = (call.receiver as Group).name;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Active Call with $receiverName'),
      ),
      body: Center(
        child: Text('In ${call.type} Call with $receiverName'),
      ),
    );
  }
}
