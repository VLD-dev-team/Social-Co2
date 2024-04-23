import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_co2/providers/FeedProvider.dart';
import 'package:social_co2/screens/widgets/FeedPost.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(builder: ((context, PROVIDERVALUES, child) {
      if (PROVIDERVALUES.error != "") {
        return Card(
          child: Text(
            "Erreur lors du chargement du feed : ${PROVIDERVALUES.error}",
            style: const TextStyle(color: Colors.red),
          ),
        );
      } else if (PROVIDERVALUES.feed.isEmpty) {
        return Container(
            margin: const EdgeInsets.all(20),
            child: const Text(
              "Votre Feed est vide, n'hésitez pas à poster quelque chose !",
              style: TextStyle(color: Colors.white),
            ));
      } else {
        return Column(
          children: [
            (PROVIDERVALUES.loading)
                ? const SizedBox(
                    width: 20, height: 20, child: CircularProgressIndicator())
                : const SizedBox(),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return FeedPost(postData: PROVIDERVALUES.feed[index]);
                },
                separatorBuilder: (context, index) => const SizedBox(height: 5),
                itemCount: PROVIDERVALUES.feed.length),
          ],
        );
      }
    }));
  }
}
