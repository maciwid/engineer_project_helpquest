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
                  builder: (context) => QuestDetails(quest.qid))
              );
            },
            child: Card(
              margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
              child: Container(
                decoration: (quest.region.isEmpty)? listItemDecoration2 :listItemDecoration,
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    ListTile(
                      focusColor: primaryColor2shade1,
                      title: Text(quest.title, style: mediumTextStyle,),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment:CrossAxisAlignment.start,
                          children: [
                            Text("Status: ${quest.status}",style: detailsTextStyle),
                            Text("Employer: ${snapshot.data.username}", style: detailsTextStyle),
                            Text("Category: ${quest.category}",style: detailsTextStyle),
                            Visibility(
                                visible: quest.region.isNotEmpty,
                                child: Text("Region: ${quest.region}",style: detailsTextStyle)),
                            Text("Prize: ${quest.prize} credits",style: detailsTextStyle),
                            Text("Description: ${quest.description}",style: detailsTextStyle)
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
