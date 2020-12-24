import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:helpquest/models/quest.dart';
import 'package:helpquest/models/user.dart';
import 'file:///C:/Users/macie/Documents/helpquest/helpquest/lib/screens/quest_views/quest_form.dart';
import 'package:helpquest/screens/pages/chat.dart';
import 'package:helpquest/screens/pages/dashboard.dart';
import 'package:helpquest/screens/pages/add.dart';
import 'package:helpquest/screens/pages/profile.dart';
import 'package:helpquest/services/auth.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:helpquest/shared/local_data.dart';
import 'package:provider/provider.dart';
import 'file:///C:/Users/macie/Documents/helpquest/helpquest/lib/screens/quest_views/quest_list.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  //int currentTab = 0;

  final List<Widget> pages = [
    Dashboard(),
    Add(),
    Chat(),
    Profile(),
  ];

  Widget currentPage = Dashboard();

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<User>(
      stream:  DatabaseService(key: user.uid).userData,
      builder: (context, snapshot) {
        User userData = snapshot.data;
        LocalData.myName = userData.username;
        LocalData.uid = user.uid;
        return snapshot.hasData ? Scaffold(
          body: PageStorage(
            child: currentPage,
            bucket: bucket,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          //Bottom App Bar
          bottomNavigationBar: CurvedNavigationBar(
            color: primaryColor2shade1,
            backgroundColor: primaryColor1,
            height: 60,
            items: <Widget>[
              Icon(Icons.dashboard, size: 30, color: primaryColor1shade,),
              Icon(Icons.add, size: 30,  color: primaryColor1shade,),
              Icon(Icons.chat, size: 30,  color: primaryColor1shade,),
              Icon(Icons.person, size: 30,  color: primaryColor1shade,),
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
        ) : Container();
      }
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


