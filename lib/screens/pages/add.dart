import 'package:flutter/material.dart';
import 'package:helpquest/screens/quest_views/quest_form.dart';
import 'package:helpquest/shared/constants.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {

  void _showCreateQuestPanel(bool isLocal){
    showModalBottomSheet(context: context, builder: (context){
      return QuestFormCreate(isLocal);
    }, isScrollControlled:true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context, "Add Quest"),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 50.0, horizontal: 10.0),
        decoration: boxBackgroundDecoration,
        child: Column(
          children: [
            SizedBox(height: 40,),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 90),
              child: ButtonTheme(
                buttonColor: Colors.pink[400],
                minWidth: double.infinity,
                child: RaisedButton(
                  child: Text(
                    'Create Local Quest',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: (){
                    _showCreateQuestPanel(true);
                  }),
              ),
            ),
            SizedBox(height: 40,),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 90),
              child: ButtonTheme(
                buttonColor: Colors.pink[400],
                minWidth: double.infinity,
                child: RaisedButton(
                    child: Text(
                      'Create Virtual Quest',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: (){
                      _showCreateQuestPanel(false);
                    }),
              ),
            ),
          ],
        )
      )
    );
  }
}
