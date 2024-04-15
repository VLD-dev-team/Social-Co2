import 'package:flutter/material.dart';
import 'package:social_co2/classes/post.dart';
import 'package:social_co2/styles/CardStyles.dart';

class FeedPost extends StatelessWidget {
  final SCO2Post postData;

  const FeedPost({
    super.key,
    required this.postData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: primaryCardColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
              leading: CircleAvatar(
                radius: 360,
                backgroundImage: (postData.userPhotoURL == null)
                    ? null
                    : NetworkImage('${postData.userPhotoURL}'),
                backgroundColor: Colors.green,
                child: (postData.userPhotoURL == null)
                    ? const Icon(Icons.account_box)
                    : null,
              ),
              title: Text('${postData.userName}'),
              subtitle: Text(postData.postCreatedAt.toIso8601String())),
          Text('postData')
        ],
      ),
    );
  }
}
