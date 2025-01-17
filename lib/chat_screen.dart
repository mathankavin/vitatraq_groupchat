import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:vitatraq_chart/audio_video_screen.dart';
import 'package:vitatraq_chart/group_chat_example.dart';
import 'package:vitatraq_chart/group_chat_screen.dart';
import 'package:intl/intl.dart';
import 'package:cometchat_calls_sdk/cometchat_calls_sdk.dart';

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupIdController = TextEditingController();


 
void createNewGroup(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CometChatCreateGroup(
        onCreateTap: (Group group) {
          print('testing...');
          selectUsersAndCreateGroup(context, group);
        },
      ),
    ),
  );
}

void selectUsersAndCreateGroup(BuildContext context, Group group) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CometChatUsers(
        selectionMode: SelectionMode.multiple,
        activateSelection: ActivateSelection.onClick,
        onSelection: (List<User>? selectedUsersList, BuildContext context) {
          print('selection');
          if (selectedUsersList == null || selectedUsersList.isEmpty) {
            debugPrint("No users selected");
          } else {
            createGroupWithMembers(context, group, selectedUsersList);
          }
        },
      ),
    ),
  );
}

void createGroupWithMembers(
    BuildContext context, Group group, List<User> selectedUsersList) {
  CometChat.createGroup(
    group: group,
    onSuccess: (Group createdGroup) {
      List<GroupMember> groupMembers = selectedUsersList.map((user) {
        return GroupMember.fromUid(
          uid: user.uid,
          name: user.name,
          scope: CometChatMemberScope.participant,
        );
      }).toList();

      CometChat.addMembersToGroup(
        guid: createdGroup.guid,
        groupMembers: groupMembers,
        onSuccess: (group) {
          debugPrint("Group successfully created!");
          navigateToGroupChat(context, createdGroup);
        },
        onError: (CometChatException error) {
          debugPrint(error.message);
        },
      );
    },
    onError: (CometChatException error) {
      debugPrint(error.message);
    },
  );
}

//Test by First
// void navigateToGroupChat(BuildContext context, Group group) {
//   Navigator.popUntil(context, (route) => route.isFirst); // Pop all previous screens
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => CometChatConversationsWithMessages(
//         group: group,
//         conversationsConfiguration: const ConversationsConfiguration(
//           disableUsersPresence: true,
//         ),
        
//       ),
//     ),
//   );
// }

//Test by second
void navigateToGroupChat(BuildContext context, Group group) {
  Navigator.popUntil(context, (route) => route.isFirst); // Pop all previous screens
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CometChatConversationsWithMessages(
        group: group,
        conversationsConfiguration: const ConversationsConfiguration(
          disableUsersPresence: true,
        ),
        messageConfiguration: const MessageConfiguration(
          messageHeaderConfiguration: MessageHeaderConfiguration(
            disableUserPresence: false, // Enable/disable status indicators
            statusIndicatorStyle: StatusIndicatorStyle(), // Customize indicator style
          ),
        ),
      ),
    ),
  );
}



  void createGroup() {
    //Step-1 Define the group details


    String groupName = _groupNameController.text.trim();
    String groupId = _groupIdController.text.trim();
    String groupType = 'public'; // Group type: PUBLIC, PRIVATE, or PASSWORD

    if (groupName.isNotEmpty && groupId.isNotEmpty) {

    //Step-2 Create a Group object

      Group group = Group(
        guid: groupId,
        name: groupName,
        type: groupType,
      );
selectUsersAndCreateGroup(context, group);

    }
  }

void addMemberToGroup(String groupId, String userId) {
  CometChat.addMembersToGroup(
    guid: groupId,
    groupMembers: [GroupMember(uid: userId, scope: GroupMemberScope.participant, name: '', status: '', role: '')],
  
    onError: (CometChatException e) {
      print("Adding members failed: ${e.message}");
    }, onSuccess: (Map<String?, String?> result) {  },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Group"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(labelText: "Group Name"),
            ),
            TextField(
              controller: _groupIdController,
              decoration: InputDecoration(labelText: "Group ID"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createGroup,
              child: Text("Create Group"),
            ),
          ],
        ),
      ),
    );
  }
}

class ConversationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversations"),
      ),
      body: CometChatConversations(
        appBarOptions: [
          InkWell(
            onTap: () {
              print('testing...');
              // TODO("Not yet implemented")
            },
            child: const Icon(Icons.ac_unit, color: Color(0xFF6851D6)),
          ),
          const SizedBox(width: 10)
        ],
        //DatePattern

        // datePattern: (conversation) {
        //   return DateFormat('HH:mm').format(conversation.updatedAt!);
        // },

        showBackButton: false,
        title: 'Group chats',
        textFormatters: [
          CometChatMentionsFormatter(
            messageBubbleTextStyle:
                (theme, alignment, {forConversation = false}) => TextStyle(
                    color: alignment == BubbleAlignment.left
                        ? Colors.orange
                        : Colors.pink,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
          )
        ],
        //     listItemView: (conversation) {
        //       return CustomListItems(
        //   name: (conversation.conversationWith) is User ? ((conversation.conversationWith) as User).name : ((conversation.conversationWith) as Group).name,
        //   lastMessageTime: conversation.updatedAt!,
        //   avatarUrl: (conversation.conversationWith) is User ? ((conversation.conversationWith) as User).avatar : ((conversation.conversationWith) as Group).icon,
        // );
        //     },
        selectionMode: SelectionMode.multiple,
        onSelection: (list) => {
          print('listlistlistlist$list')
          // TODO("Not yet implemented")
        },
        onBack: () {
          print('back up call');
          Navigator.pop(context);
        }, // Define the action you want to perform on back press Navigator.pop(context); },
        onItemTap: (conversation) {
          if (conversation.conversationType == 'user') {
            final user = conversation.conversationWith as User;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => 
                ChatScreen(
                  conversationWithUid: user.uid,
                  conversationWithName: user.name ?? 'Unknown',
                  conversationType: conversation.conversationType,
                ),

                //Audio Video Call
                //  ChatScreenNew(
                //   conversationWithUid: user.uid,
                //   conversationWithName: user.name ?? 'Unknown',
                //   conversationType: conversation.conversationType,
                // ),

              ),
            );
          } else if (conversation.conversationType == 'group') {
            final group = conversation.conversationWith as Group;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  conversationWithUid: group.guid,
                  conversationWithName: group.name ?? 'Unknown',
                  conversationType: conversation.conversationType,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

// class ChatScreen extends StatelessWidget {
//   final String conversationWithUid;
//   final String conversationWithName;
//   final String conversationType;

//   const ChatScreen({
//     super.key, 
//     required this.conversationWithUid,
//     required this.conversationWithName,
//     required this.conversationType,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(conversationWithName),
//       ),
//       body: CometChatMessages(
//         user: conversationType == 'user'
//             ? User(name: conversationWithName, uid: conversationWithUid)
//             : null,
//         group: conversationType == 'group'
//             ? Group(
//                 guid: conversationWithUid,
//                 name: conversationWithName,
//                 type: 'public')
//             : null,
//       ),
//     );
//   }
// }
 
class ChatScreen extends StatelessWidget {
  final String conversationWithName;
  final String conversationWithUid;
  final String conversationType;

  ChatScreen({
    required this.conversationWithName,
    required this.conversationWithUid,
    required this.conversationType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(conversationWithName),
      ),
      body: Stack(
        children: [
          // CometChatMessages widget to display chat interface
          CometChatMessages(
            user: conversationType == 'user'
                ? User(name: conversationWithName, uid: conversationWithUid)
                : null,
            group: conversationType == 'group'
                ? Group(
                    guid: conversationWithUid,
                    name: conversationWithName,
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
                    _initiateAudioCall(conversationWithUid);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.videocam, color: Colors.blue),
                  onPressed: () {
                    // Handle video call
                    print('Video call button pressed');
                    _initiateVideoCall(conversationWithUid);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

 void _initiateAudioCall(String receiverUid) {
  var sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  var call = Call(
    sessionId: sessionId,
    receiverUid: receiverUid,
    receiverType: conversationType == 'user'
        ? ReceiverTypeConstants.user
        : ReceiverTypeConstants.group,
    type: 'audio',
  );

  
 CometChat.initiateCall(call,    onSuccess: (Call initiatedCall) {
      print('Video Call initiated: ${initiatedCall.toJson()}');
    },
    onError: (CometChatException error) {
      print('Video Call failed: $error');
    },);

}

void _initiateVideoCall(String receiverUid) {
  var sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  var call = Call(
    sessionId: sessionId,
    receiverUid: receiverUid,
    receiverType: conversationType == 'user'
        ? ReceiverTypeConstants.user
        : ReceiverTypeConstants.group,
    type: 'video',
  );
 CometChat.initiateCall(call,    onSuccess: (Call initiatedCall) {
      print('Video Call initiated: ${initiatedCall.toJson()}');
    },
    onError: (CometChatException error) {
      print('Video Call failed: $error');
    },);
 
}



}


 
class CustomListItems extends StatelessWidget {
  final String name;
  final DateTime? lastMessageTime;
  final String? avatarUrl;

  const CustomListItems({
    super.key,
    required this.name,
    this.lastMessageTime,
    this.avatarUrl,
  });

  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(
              color: Color(0xFF6851D6), width: 1), // Example border color
          borderRadius: BorderRadius.circular(8.0),
          color: Color(0xFFEEEEEE)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                lastMessageTime == null
                    ? Container()
                    : Text(formatDateTime(lastMessageTime!)),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          if (avatarUrl != null)
            ClipOval(
              child: Image.network(
                avatarUrl!,
                width: 40.0,
                height: 40.0,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    size: 40.0,
                  );
                },
              ),
            )
          else
            const Icon(
              Icons.person,
              size: 40.0,
            ),
        ],
      ),
    );
  }
}


