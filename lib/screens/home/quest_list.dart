import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:helpquest/models/quest.dart';
import 'package:helpquest/screens/home/quest_tile.dart';

    class QuestList extends StatefulWidget {
      @override
      _QuestListState createState() => _QuestListState();
    }
    
    class _QuestListState extends State<QuestList> {
      @override
      Widget build(BuildContext context) {

        final quests = Provider.of<List<Quest>>(context) ?? [];

        //print(quests);
        return ListView.builder(
          itemCount: quests.length,
          itemBuilder: (context, index){
          return QuestTile(quest: quests[index]);
        },
        );
      }
    }
    