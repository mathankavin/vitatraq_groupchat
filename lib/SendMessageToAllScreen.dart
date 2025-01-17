import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

class SendMessageToAllScreen extends StatefulWidget {
  final Group group;

  SendMessageToAllScreen({required this.group});

  @override
  _SendMessageToAllScreenState createState() => _SendMessageToAllScreenState();
}

class _SendMessageToAllScreenState extends State<SendMessageToAllScreen> {
  final TextEditingController _messageController = TextEditingController();

  void sendMessageToAllMembers() async {
    List<User> members = await _fetchGroupMembers(widget.group.guid);
    for (User member in members) {
      _sendMessage(member, _messageController.text);
    }
  }

  Future<List<User>> _fetchGroupMembers(String guid) async {
    List<User> members = [];
    try {
      GroupMembersRequest groupMembersRequest = GroupMembersRequestBuilder(guid).build();
      members = await groupMembersRequest.fetchNext(onSuccess: (List<GroupMember> groupMemberList) {  }, onError: (CometChatException excep) {  });
    } catch (e) {
      print('Error fetching group members: $e');
    }
    return members;
  }

  void _sendMessage(User member, String messageText) {
    TextMessage message = TextMessage(
      receiverUid: member.uid,
      text: messageText,
      receiverType: "user", type: 'public',
    );

    CometChat.sendMessage(message, onSuccess: (TextMessage message) {
      print('Message sent to ${member.name}');
    }, onError: (CometChatException e) {
      print('Error sending message to ${member.name}: ${e.message}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Message to All Members')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: sendMessageToAllMembers,
              child: Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
