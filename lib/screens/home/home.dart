import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:helpquest/models/user.dart';
import 'package:helpquest/screens/pages/chat.dart';
import 'package:helpquest/screens/pages/dashboard.dart';
import 'package:helpquest/screens/pages/add.dart';
import 'package:helpquest/screens/pages/profile.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

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
    return StreamProvider.value(
      value:  DatabaseService(key: user.uid).userData,
      child: Scaffold(
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
        )
            //: Container();

    );
  }
}


