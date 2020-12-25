import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpquest/models/quest.dart';
import 'package:helpquest/screens/quest_views/quest_list.dart';
import 'package:helpquest/services/auth.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:helpquest/models/user.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    return StreamProvider<List<Quest>>.value(
      value: DatabaseService().quests,
      child: Scaffold(
        appBar: AppBar(
            title: Text('Your Profile',
            style: titleTextStyle),
            backgroundColor: primaryColor2shade1,
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () async {
                    await _auth.signOut(userData.uid);
                  },
                  icon: Icon(Icons.person,
                      color: primaryColor1),

                  label: Text('logout', style: mediumTextStyle,))
            ]

        ),
          body: Container(
            decoration: boxBackgroundDecoration,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    //decoration: boxBackgroundDecoration,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Username:"),
                            //Text(user.username),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Bio:"),
                            //Text(user.bio),
                          ],
                        ),
                          Expanded(child: SizedBox(
                            height: 100,
                              child: QuestList(true)))
                      ],
                    )
                  ),



      ),
    );
  }
}
