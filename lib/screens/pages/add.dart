import 'package:flutter/material.dart';
import 'file:///C:/Users/macie/Documents/helpquest/helpquest/lib/screens/quest_views/quest_form.dart';
import 'package:helpquest/shared/constants.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {

  void _showCreateQuestPanel(bool isLocal){
    showModalBottomSheet(context: context, builder: (context){
      return QuestFormCreate(isLocal);
    });
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
            ButtonTheme(
              minWidth: double.infinity,
              child: RaisedButton(
              color: Colors.pink[900],
                child: Text(
                  'Create Local Quest',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: (){
                  _showCreateQuestPanel(true);
                }),
            ),
            SizedBox(height: 40,),
            ButtonTheme(
              minWidth: double.infinity,
              child: RaisedButton(
                  color: Colors.pink[900],
                  child: Text(
                    'Create Virtual Quest',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: (){
                    _showCreateQuestPanel(false);
                  }),
            ),
          ],
        )
      )
    );
  }
}
