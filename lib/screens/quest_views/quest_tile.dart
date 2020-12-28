import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpquest/models/quest.dart';
import 'package:helpquest/models/user.dart';
import 'package:helpquest/screens/quest_views/quest_view.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:helpquest/shared/loading.dart';
class QuestTile extends StatelessWidget {

  final Quest quest;
  QuestTile({this.quest});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
      stream: DatabaseService(key: quest.employerID).userData,
      builder: (context, snapshot) {
        return (snapshot.hasData) ? Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => QuestFormView(quest))
              );
            },
            child: Card(
              margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
              child: Container(
                decoration: inputBoxDecoration,
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    ListTile(
                      focusColor: primaryColor2shade1,
                      title: Text(quest.title),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment:CrossAxisAlignment.start,
                          children: [
                            Text("Employer: ${snapshot.data.username}"),
                            Text("Category: ${quest.category}"),
                            Text("Prize: ${quest.prize} credits"),
                            Text("Status: ${quest.status}"),
                            Text("Description: ${quest.description}")
                          ],
                        ),
                      )
                    ),
                  ],
                ),
              )
            ),
          )
        ) : Loading();
      }
    );
  }
}
