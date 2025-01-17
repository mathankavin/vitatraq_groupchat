import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

class GroupChatScreen extends StatefulWidget {
  final String roomId;
  final String roomName;

  GroupChatScreen({required this.roomId, required this.roomName});

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  void sendMessageToAllMembers() async {
    // Fetch group members
    List<User> members = await _fetchGroupMembers(widget.roomId);
    
    // Send message to each member
    String messageText = _messageController.text.trim();
    for (User member in members) {
      _sendMessage(member, messageText);
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
      receiverType: 'user', type: '',
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
      appBar: AppBar(
        title: Text(widget.roomName),
      ),
      body: Column(
        children: [
          Expanded(
            child: CometChatMessages(
              group: Group(guid: widget.roomId, name: widget.roomName, type: 'public'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Enter your message here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessageToAllMembers,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
