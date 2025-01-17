import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
 
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupChatScreen(
                  roomId: "cometchat-guid-1", // Replace with actual group ID
                  roomName: "Hiking Group", // Replace with actual group name
                ),
              ),
            );
          },
          child: Text("Go to Group Chat"),
        ),
      ),
    );
  }
}

class GroupChatScreen extends StatelessWidget {
  final String roomId;
  final String roomName;

  GroupChatScreen({required this.roomId, required this.roomName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(roomName),
      ),
      body: CometChatMessages(
        group: Group(guid: roomId, name: roomName, type: 'public'),
       
      ),
    );
  }
}
