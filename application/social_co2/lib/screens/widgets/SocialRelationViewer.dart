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
  @override
  void initState() {
    super.initState();

    Provider.of<FriendshipsProvider>(context, listen: false).getFriends();
    Provider.of<FriendshipsProvider>(context, listen: false)
        .getPendingRequests();
    Provider.of<FriendshipsProvider>(context, listen: false).getBlockedUsers();
    Provider.of<FriendshipsProvider>(context, listen: false)
        .getFriendRequests();
  }

  @override
  Widget build(BuildContext context) {
    String selectedList = availablesUsersList[0]['type'];

    return Consumer<FriendshipsProvider>(
      builder: (context, friendshipsValues, child) => Container(
        margin: const EdgeInsets.only(top: 0, bottom: 10, left: 10, right: 10),
        decoration: primaryCard,
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          100)), //arrondir les bords de la Card
                  child: Wrap(children: [
                    // Pour toute les options possible, on génére le widget
                    for (var element in availablesUsersList)
                      IconButton(
                        selectedIcon: Icon(
                          element['icon'],
                          color: Colors.green,
                        ),
                        isSelected: (selectedList == element['type']),
                        onPressed: () {
                          setState(() {
                            selectedList = element['type'];
                          });
                        },
                        icon: Icon(element['icon']),
                      ),
                  ]),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: double.infinity,
                child: (friendshipsValues.loading)
                    ? const Center(child: CircularProgressIndicator())
                    : listUser(friendshipsValues.pendingRequests, selectedList),
              ),
            )
          ],
        ),
      ),
    );
  }

  ListView listUser(List<SCO2user> list, String actionType) {
    if (list.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: 50),
          Icon(Icons.check_circle_outline),
          SizedBox(height: 5),
          Text(
              "Aucun élément à afficher. $actionType", // TODO: enlever actiontype
              textAlign: TextAlign.center)
        ],
      );
    } else {
      return ListView.separated(
          itemBuilder: (context, index) => userTile(list[index], actionType),
          separatorBuilder: (context, index) => const SizedBox(height: 5),
          itemCount: list.length);
    }
  }

  ListTile userTile(SCO2user user, String actionType) {
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
    );
  }
}
