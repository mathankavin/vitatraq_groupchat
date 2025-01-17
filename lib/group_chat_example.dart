import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/material.dart';
 
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
      ),
    ),
  );
}
