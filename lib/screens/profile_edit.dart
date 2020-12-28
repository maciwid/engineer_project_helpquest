import 'package:flutter/material.dart';
import 'package:helpquest/models/user.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:provider/provider.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  String _currentUsername;
  String _currentBio;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(key: user.uid).userData,
      builder: (context, snapshot) {
        return Container(
          decoration: boxBackgroundDecoration,
          child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 40.0),
                    Text(
                      'Edit Profile',
                      style: titleTextStyle,
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      style: mediumTextStyle,
                      initialValue: snapshot.data.username,
                      decoration: textInputDecoration.copyWith(hintText: "username..."),
                      validator: (val) => val.isEmpty ? 'Please enter an username':null,
                      onChanged: (val) => setState(()=> _currentUsername = val),
                    ),
                    SizedBox(height: 20.0),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Bio:", style: simpleTextStyle,)),
                    TextFormField(
                      style: mediumTextStyle,
                      initialValue: snapshot.data.bio,
                      decoration: textInputDecoration.copyWith(hintText: "bio..."),
                      onChanged: (val) => setState(()=> _currentBio = val),
                    ),
                    SizedBox(height: 50.0),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 90),
                      child: RaisedButton(
                        color: Colors.pink[400],
                        child:Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: ()async{
                          if(_formKey.currentState.validate()){
                            await DatabaseService(key: user.uid).updateUserData(
                                _currentUsername ?? snapshot.data.username,
                                snapshot.data.email,
                                _currentBio ?? snapshot.data.bio,
                                snapshot.data.isOnline);
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 50.0),
                  ],
                ),
              )
          ),
        );
      }
    );
  }
}
