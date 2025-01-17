import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupIdController = TextEditingController();
  String _selectedType = "public";

  void _createGroup() async {
    String groupName = _groupNameController.text.trim();
    String groupId = _groupIdController.text.trim();
    if (groupName.isNotEmpty && groupId.isNotEmpty) {
      Group group = Group(guid: groupId, name: groupName, type: _selectedType);

      try {
        await CometChat.createGroup(
 
          onSuccess: (Group createdGroup) {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => AddMembersScreen(group: createdGroup),
            //   ),
            // );
          },
          onError: (CometChatException e) {
            print('Error creating group: ${e.message}');
          }, group: group,
        );
      } catch (e) {
        print('Exception: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Group')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _groupIdController,
              decoration: InputDecoration(labelText: 'Group ID'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(labelText: 'Group Name'),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedType = newValue!;
                });
              },
              items: <String>['public', 'private', 'password']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createGroup,
              child: Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }
}
