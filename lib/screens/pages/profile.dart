import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpquest/models/filter.dart';
import 'package:helpquest/models/quest.dart';
import 'package:helpquest/screens/profile_edit.dart';
import 'package:helpquest/screens/quest_views/quest_list.dart';
import 'package:helpquest/services/auth.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:helpquest/models/user.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  bool _showCompleted = true;
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
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                backgroundColor: primaryColor2shade1,
                heroTag: "editBtn",
                child: Icon(Icons.settings),
                onPressed: (){
                  showModalBottomSheet(context: context, builder: (context){
                    return ProfileEdit();
                  }, isScrollControlled:true);
                },
              ),
            ),
          ),
          body: Container(
            decoration: boxBackgroundDecoration,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    //decoration: boxBackgroundDecoration,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text("Username: ", style: simpleTextStyle),
                              Text(userData.username, style: mediumTextStyle,),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Bio:  ", style: simpleTextStyle),
                              Flexible(child: Text(userData.bio, style: mediumTextStyle)),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Your quests:", style: simpleTextStyle,)),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(color: primaryColor2shade1),
                            alignment: Alignment.center,
                            child: CheckboxListTile(
                              title: Text("Hide completed", style: simpleTextStyle),
                              value: _showCompleted,
                              activeColor: primaryColor1shade,
                              onChanged: (val){
                                setState(() {
                                  _showCompleted = val;
                                });
                              },
                            ),
                          ),
                            Expanded(child: SizedBox(
                              height: 100,
                                child: QuestList(true, _showCompleted, Filter())))
                        ],
                      ),
                    )
                  ),



      ),
    );
  }
}
