import 'package:flutter/material.dart';
import 'package:helpquest/models/quest.dart';
class QuestTile extends StatelessWidget {

  final Quest quest;
  QuestTile({this.quest});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: CircleAvatar(
          radius: 25.0,
          //backgroundColor: Colors.teal[quest.priority],
          ),
          title: Text(quest.title),
          subtitle: Text(quest.category)
        )
      )
    );
  }
}
