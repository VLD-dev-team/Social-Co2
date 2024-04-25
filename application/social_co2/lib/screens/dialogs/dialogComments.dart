import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/classes/post.dart';
import 'package:social_co2/providers/FeedProvider.dart';

class dialogComments extends StatefulWidget {
  SCO2Post postData;

  dialogComments({
    super.key,
    required this.postData,
  });

  @override
  State<StatefulWidget> createState() => _dialogComments(postData: postData);
}

class _dialogComments extends State<dialogComments> {
  bool loading = false;
  TextEditingController controller = TextEditingController();
  bool editingNewComment = false;
  final SCO2Post postData;

  _dialogComments({required this.postData});

  final Widget userphoto = (FirebaseAuth.instance.currentUser!.photoURL != null)
      ? SizedBox(
          width: 45,
          height: 45,
          child: CircleAvatar(
            radius: 360,
            backgroundImage:
                NetworkImage('${FirebaseAuth.instance.currentUser!.photoURL}'),
          ),
        )
      : const Icon(
          Icons.account_circle_outlined,
          size: 45,
        );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FeedProvider()..getPostComment(postData.postID),
      builder: (context, child) => AlertDialog(
        icon: const Icon(Icons.comment),
        title: Text('${postData.postCommentsNumber} commentaires'),
        content: Consumer<FeedProvider>(
          builder: (context, PROVIDERVALUES, child) => SizedBox(
            width: 400,
            height: 600,
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    // TODO: afficher les valeurs
                    title: Text(PROVIDERVALUES.postComments[postData.postID]
                        .toString()),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 5),
                itemCount: postData.postCommentsNumber!),
          ),
        ),
        actionsPadding: const EdgeInsets.all(20),
        actions: [
          Consumer<FeedProvider>(
            builder: (context, PROVIDERVALUES, child) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                userphoto,
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      minLines: 1,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          hintText: "Entrez votre commentaire ici !"),
                      controller: controller,
                      onChanged: (value) {
                        setState(() {
                          editingNewComment = (value != "");
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                    onPressed: (editingNewComment &&
                            !PROVIDERVALUES.postingComment)
                        ? () {
                            PROVIDERVALUES
                                .sendComment(postData.postID, controller.text)
                                .then((value) {
                              PROVIDERVALUES.getPostComment(postData.postID);
                              setState(() {
                                postData.postCommentsNumber =
                                    postData.postCommentsNumber! + 1;
                              });
                            });
                            setState(() {
                              controller.text = "";
                            });
                          }
                        : null,
                    icon: const Icon(Icons.send))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
