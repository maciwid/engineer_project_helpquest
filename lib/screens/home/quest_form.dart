import 'package:flutter/material.dart';
import 'package:helpquest/models/user.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:helpquest/shared/loading.dart';
import 'package:provider/provider.dart';
class QuestForm extends StatefulWidget {
  @override
  _QuestFormState createState() => _QuestFormState();
}

class _QuestFormState extends State<QuestForm> {
  final _formKey = GlobalKey<FormState>();
  // form values
  String _currentTitle;
  String _currentTopic;
  String _currentDescription;
  String _currentStatus;
  int _currentPriority;
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){

          UserData userData = snapshot.data;
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
                    initialValue: userData.title,
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
                        await DatabaseService(uid: user.uid).updateUserData(
                            _currentTitle ?? userData.title,
                            _currentTopic ?? userData.topic,
                            _currentDescription ?? userData.description,
                            _currentStatus ?? userData.status,
                            _currentPriority ?? userData.priority);
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
