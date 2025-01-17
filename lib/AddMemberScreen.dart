import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

class AddMembersScreen extends StatelessWidget {
  final Group group;

  AddMembersScreen({required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Members')),
      body: CometChatAddMembers(
        group: group,
        onBack: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
