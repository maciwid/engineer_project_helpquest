import 'package:flutter/material.dart';
import 'package:helpquest/models/filter.dart';
import 'package:helpquest/models/quest.dart';
import 'package:helpquest/screens/quest_views/filter_settings.dart';
import 'package:helpquest/screens/quest_views/quest_list.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Filter _filter = new Filter();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Quest>>.value(
      value: DatabaseService().quests,
      child: Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar:  AppBar(
            title: Text('Browse Quests',
                style: titleTextStyle),
            backgroundColor: primaryColor2shade1,
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () async {
                    setState(() {
                      _filter = Filter();
                    });
                  },
                  icon: Icon(Icons.clear,
                      color: primaryColor1),

                  label: Text('reset filter', style: mediumTextStyle,))
            ]

        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor2shade1,
          heroTag: "editBtn",
          child: Icon(Icons.filter_list),
          onPressed: (){
            showModalBottomSheet(context: context, builder: (context){
              return FilterSettings(callback: (val) => setState(() => _filter = val), initFilter: _filter,);
            }, isScrollControlled:true);
          },
        ),
        body: Container(
            decoration: boxBackgroundDecoration,
            child: QuestList(false, false, _filter)),
      ),
    );
  }
}
