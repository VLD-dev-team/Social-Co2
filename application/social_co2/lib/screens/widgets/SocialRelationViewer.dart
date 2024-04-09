import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/classes/SCO2user.dart';
import 'package:social_co2/collections/friendshipsData.dart';
import 'package:social_co2/providers/FriendshipsProvider.dart';
import 'package:social_co2/styles/CardStyles.dart';

class SocialRelationViewer extends StatefulWidget {
  const SocialRelationViewer({super.key});

  @override
  State<StatefulWidget> createState() => _SocialRelationViewerState();
}

class _SocialRelationViewerState extends State<SocialRelationViewer> {
  Map selectedList = availablesUsersList[0];

  @override
  Widget build(BuildContext context) {
    return Consumer<FriendshipsProvider>(
      builder: (context, friendshipsValues, child) => Container(
        margin: const EdgeInsets.only(top: 0, bottom: 10, left: 10, right: 10),
        decoration: primaryCard,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Text(
                        selectedList['name'],
                        style: const TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            100)), //arrondir les bords de la Card
                    child: Wrap(children: [
                      // Pour toute les options possible, on génére le widget
                      for (var element in availablesUsersList)
                        CircleAvatar(
                          backgroundColor:
                              (selectedList['type'] == element['type'])
                                  ? const Color.fromARGB(100, 150, 150, 150)
                                  : Colors.transparent,
                          child: IconButton(
                            selectedIcon: Icon(
                              element['icon'],
                              color: Colors.green,
                            ),
                            isSelected:
                                (selectedList['type'] == element['type']),
                            onPressed: () {
                              setState(() {
                                selectedList = element;
                              });
                            },
                            icon: Icon(
                              element['icon'],
                              color: Colors.black,
                            ),
                          ),
                        ),
                    ]),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                height: double.infinity,
                child: (friendshipsValues.loading)
                    ? const Center(child: CircularProgressIndicator())
                    : listUser(
                        getListFromActionType(
                            friendshipsValues, selectedList['type']),
                        selectedList['type'],
                        friendshipsValues),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<SCO2user> getListFromActionType(
      FriendshipsProvider provider, String actionType) {
    switch (actionType) {
      case 'friendRequests':
        return provider.friendRequests;
      case 'blockedUsers':
        return provider.blockedUsers;
      case 'pendingRequests':
        return provider.pendingRequests;
      default:
        return provider.friends;
    }
  }

  ListView listUser(List<SCO2user> list, String actionType,
      FriendshipsProvider providerData) {
    if (list.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 50),
          Icon(Icons.check_circle_outline),
          SizedBox(height: 5),
          Text("Aucun élément à afficher.", textAlign: TextAlign.center)
        ],
      );
    } else {
      return ListView.separated(
          itemBuilder: (context, index) =>
              userTile(list[index], actionType, providerData),
          separatorBuilder: (context, index) => const SizedBox(height: 5),
          itemCount: list.length);
    }
  }

  ListTile userTile(
      SCO2user user, String actionType, FriendshipsProvider providerData) {
    return ListTile(
      title: Text('${user.displayName}'),
      subtitle: Text(user.userID),
      leading: SizedBox(
        width: 45,
        height: 45,
        child: CircleAvatar(
          radius: 360,
          backgroundImage: (user.avatarURL == null)
              ? null
              : NetworkImage('${user.avatarURL}'),
          backgroundColor: Colors.green,
          child:
              (user.avatarURL == null) ? const Icon(Icons.account_box) : null,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /*   if (actionType == 'friends')
            IconButton.filled(
                onPressed: () {
                  providerData.
                },
                icon: const Icon(
                  Icons.person_remove,
                  color: Colors.black,
                )), */
          if (actionType == 'friendRequests')
            IconButton.filled(
                onPressed: () {
                  providerData.acceptFriendRequest(user.userID);
                },
                icon: const Icon(Icons.check, color: Colors.green)),
          if (actionType == 'friendRequests')
            IconButton.filled(
                onPressed: () {
                  providerData.refuseFriendRequest(user.userID);
                },
                icon: const Icon(Icons.close, color: Colors.red)),
          if (actionType == 'friendRequests' || actionType == 'friends')
            IconButton.filled(
                onPressed: () {
                  providerData.blockUser(user.userID);
                },
                icon: const Icon(Icons.block,
                    color: Color.fromARGB(255, 204, 14, 0))),
          if (actionType == 'pendingRequests')
            IconButton.filled(
                onPressed: () {
                  // TODO: pending request non annulable dans l'api
                },
                icon: const Icon(Icons.close, color: Colors.red)),
          if (actionType == 'blockedUsers')
            IconButton.filled(
                onPressed: () {
                  providerData.blockUser(user.userID);
                },
                icon: const Icon(Icons.check, color: Colors.green)),
        ],
      ),
    );
  }
}
