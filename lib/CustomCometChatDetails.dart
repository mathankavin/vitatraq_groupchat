import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

class CustomMemberList extends StatelessWidget {
  final Group group;

  CustomMemberList({required this.group});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: _fetchGroupMembers(group.guid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No members found'));
        } else {
          List<User> members = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: members.length,
            itemBuilder: (context, index) {
              User member = members[index];
              return ListTile(
                title: Text(member.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CometChatMessages(user: member),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
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
}
 
class GroupDetailsScreen extends StatelessWidget {
  final Group group;

  GroupDetailsScreen({required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Group Details')),
      body: Column(
        children: [
          Expanded(
            child: CometChatDetails(
              group: group,
            ),
          ),
         // Expanded( child: CustomCometChatDetails(group: group)),
          Divider(height: 1),
          Expanded(
            child: CustomMemberList(group: group),
          ),
        ],
      ),
    );
  }
}


class CustomCometChatDetails extends StatelessWidget {
  final Group group;

  CustomCometChatDetails({required this.group});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add other details you want to show
        Text("Group Name: ${group.name}"),
        Text("Members Count: ${group.membersCount}"),
        // Exclude "View Members" button
        // If needed, add other details or buttons here
      ],
    );
  }
}
