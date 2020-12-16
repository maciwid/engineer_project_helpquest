import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:helpquest/models/quest.dart';
import 'package:helpquest/screens/home/quest_form.dart';
import 'package:helpquest/screens/pages/chat.dart';
import 'package:helpquest/screens/pages/dashboard.dart';
import 'package:helpquest/screens/pages/map.dart';
import 'package:helpquest/screens/pages/profile.dart';
import 'package:helpquest/services/auth.dart';
import 'package:helpquest/services/database.dart';
import 'package:provider/provider.dart';
import 'package:helpquest/screens/home/quest_list.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  //int currentTab = 0;

  final List<Widget> pages = [
    Dashboard(),
    Map(),
    Chat(),
    Profile(),
  ];

  Widget currentPage = Dashboard();

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    void _showCreateQuestPanel(){
      showModalBottomSheet(context: context, builder: (context){
        return QuestFormCreate();
      });
    }
    return Scaffold(
      body: PageStorage(
        child: currentPage,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "addBtn",
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: (){
          _showCreateQuestPanel();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //Bottom App Bar
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.deepPurple,
        height: 60,
        items: <Widget>[
          Icon(Icons.dashboard, size: 30),
          Icon(Icons.map, size: 30),
          Icon(Icons.chat, size: 30),
          Icon(Icons.person, size: 30),
        ],
        animationDuration: Duration(
          milliseconds: 200
        ),
        animationCurve: Curves.bounceInOut,
        onTap: (index) {
          setState(() {
            currentPage = pages[index];
          });
        },
      ),
    );
    /*
    return StreamProvider<List<Quest>>.value(
      value: DatabaseService().quests,
      child: Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          title: Text('HelpQuest'),
          backgroundColor: Colors.grey[900],
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: Icon(Icons.person),
                label: Text('logout'))
          ]
        ),
        body: QuestList(),
      ),
    );
    */
  }
}


