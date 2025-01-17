import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:vitatraq_chart/group_chat_screen.dart';

class JoinGroupScreen extends StatefulWidget {
  final String groupId;
  final String groupName;

  JoinGroupScreen({required this.groupId, required this.groupName});

  @override
  _JoinGroupScreenState createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  void joinGroup() {
    String userId = "cometchat-uid-1"; // Replace with your user ID

    CometChat.addMembersToGroup(
      guid: widget.groupId,
      groupMembers: [GroupMember(uid: userId, scope: GroupMemberScope.participant, name: '', role: '', status: '')],
      onSuccess: (Map<String?, String?> result) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupChatScreen(roomId: widget.groupId, roomName: widget.groupName),
          ),
        );
      },
      onError: (CometChatException e) {
        print("Adding user to group failed: ${e.message}");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Join Group"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: joinGroup,
          child: Text("Join Group"),
        ),
      ),
    );
  }
}
