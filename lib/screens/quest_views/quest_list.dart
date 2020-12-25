import 'package:flutter/material.dart';
import 'package:helpquest/models/user.dart';
import 'package:provider/provider.dart';
import 'package:helpquest/models/quest.dart';
import 'package:helpquest/screens/quest_views/quest_tile.dart';

    class QuestList extends StatefulWidget {
      final bool owned;
      QuestList(this.owned);
      @override
      _QuestListState createState() => _QuestListState();
    }
    
    class _QuestListState extends State<QuestList> {
      @override
      Widget build(BuildContext context) {

        final quests = Provider.of<List<Quest>>(context) ?? [];
        final userData = Provider.of<UserData>(context);
        //print(quests);
        return ListView.builder(
          //shrinkWrap: true,
          itemCount: quests.length,
          itemBuilder: (context, index){
            if(widget.owned){
              if(quests[index].employerID==userData.uid) {
                return QuestTile(quest: quests[index]);
              }
            }
            else{
              return QuestTile(quest: quests[index]);}
        },
        );
      }
    }
    