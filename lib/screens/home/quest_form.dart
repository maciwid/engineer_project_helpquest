import 'package:flutter/material.dart';
import 'package:helpquest/models/quest.dart';
import 'package:helpquest/models/user.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:helpquest/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class QuestFormCreate extends StatefulWidget {
  @override
  _QuestFormCreateState createState() => _QuestFormCreateState();
}

class _QuestFormCreateState extends State<QuestFormCreate> {
  final _formKey = GlobalKey<FormState>();
  var uuid = Uuid();
  // form values
  String qid;
  String _currentTitle;
  String _currentCategory;
  String _currentDescription;
  String _currentStatus;
  String _currentPrize;
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

            return Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Quest settings',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration,
                      validator: (val) => val.isEmpty ? 'Please enter a name':null,
                      onChanged: (val) => setState(()=> _currentTitle = val),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration,
                      validator: (val) => val.isEmpty ? 'Please enter a name':null,
                      onChanged: (val) => setState(()=> _currentCategory = val),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration,
                      validator: (val) => val.isEmpty ? 'Please enter a name':null,
                      onChanged: (val) => setState(()=> _currentDescription = val),
                    ),
                    RaisedButton(
                      color: Colors.pink[400],
                      child:Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: ()async{
                        if(_formKey.currentState.validate()){
                          qid = uuid.v1();
                          await DatabaseService(key: qid).updateQuestData(
                              qid,
                              _currentTitle,
                              _currentCategory,
                              _currentDescription,
                              _currentStatus,
                              _currentPrize,
                              user.uid
                          );
                          Navigator.pop(context);
                        }
                      },
                    )
                  ],
                )
            );
  }
}



class QuestFormEdit extends StatefulWidget {
  @override
  _QuestFormEditState createState() => _QuestFormEditState();
}

class _QuestFormEditState extends State<QuestFormEdit> {
  final _formKey = GlobalKey<FormState>();
  // form values
  String _currentTitle;
  String _currentCategory;
  String _currentDescription;
  String _currentStatus;
  String _currentPrize;
  @override
  Widget build(BuildContext context) {

    //final user = Provider.of<User>(context);
    final quest = Provider.of<Quest>(context);

    return StreamBuilder<Quest>(
      stream: DatabaseService(key: quest.qid).quest,
      builder: (context, snapshot) {
        if(snapshot.hasData){

          Quest questData = snapshot.data;
          return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Quest settings',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: questData.title,
                    decoration: textInputDecoration,
                    validator: (val) => val.isEmpty ? 'Please enter a name':null,
                    onChanged: (val) => setState(()=> _currentTitle = val),
                  ),
                  RaisedButton(
                    color: Colors.pink[400],
                    child:Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: ()async{
                      if(_formKey.currentState.validate()){
                        await DatabaseService(key: questData.qid).updateQuestData(
                            questData.qid,
                            _currentTitle ?? questData.title,
                            _currentCategory ?? questData.category,
                            _currentDescription ?? questData.description,
                            _currentStatus ?? questData.status,
                            _currentPrize ?? questData.prize,
                            questData.employerID);
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              )
          );
        }else{
          return Loading();
        }

      }
    );
  }
}
