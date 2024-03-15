import 'package:flutter/material.dart';

class ActivitiesList extends StatelessWidget {
  bool multiSelection = false;

  ActivitiesList({
    super.key,
    required this.multiSelection,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('00:00'),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Icon(Icons.car_crash),
                )
              ],
            ),
            title: Text('Itinéraire en voiture $index'),
            subtitle: Text("15min - 45km - 200g CO2"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("+25"),
                if (multiSelection)
                  Checkbox(
                    value: false,
                    onChanged: (value) => {value == true},
                  )
              ],
            ),
          );
        });
  }
}
