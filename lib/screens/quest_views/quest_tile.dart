import 'package:flutter/material.dart';
import 'package:helpquest/models/quest.dart';
import 'package:helpquest/screens/quest_views/quest_form.dart';
import 'package:helpquest/shared/constants.dart';
class QuestTile extends StatelessWidget {

  final Quest quest;
  QuestTile({this.quest});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => QuestFormView(quest.qid))
          );
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
          child: Column(
            children: [
              ListTile(
                focusColor: primaryColor2shade1,
                title: Text(quest.title),
                subtitle: Column(
                  children: [
                    Text("Employer: ${quest.employerID}"),
                    Text("Category: ${quest.category}"),
                    Text("Prize: ${quest.prize}")
                  ],
                )
              ),
            ],
          )
        ),
      )
    );
  }
}
