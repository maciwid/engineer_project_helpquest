import 'package:flutter/material.dart';
import 'package:helpquest/models/quest.dart';
import 'package:helpquest/screens/home/quest_list.dart';
import 'package:helpquest/services/database.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Quest>>.value(
      value: DatabaseService().quests,
      child: Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
            title: Text('HelpQuest'),
            backgroundColor: Colors.grey[900],
        ),
        body: QuestList(),
      ),
    );
  }
}
