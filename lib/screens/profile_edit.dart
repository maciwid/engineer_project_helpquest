import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helpquest/models/user.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:helpquest/shared/loading.dart';
import 'package:provider/provider.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  String _currentUsername;
  String _currentBio;
  String error = '';
  bool _userExist;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(key: user.uid).userData,
      builder: (context, snapshot) {
        return (snapshot.hasData) ? Container(
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
                      validator: (val) => (val.isEmpty ) ? 'Username cannot be empty':null,
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
                    SizedBox(height: 30.0),
                    Text(
                        error,
                        style: TextStyle(color: primaryColor3,
                            fontSize: 14.0)
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 90),
                      child: RaisedButton(
                        color: Colors.pink[400],
                        child:Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: ()async{

                          final QuerySnapshot result = await Future.value(Firestore.instance
                              .collection('users')
                              .where('username', isEqualTo: _currentUsername)
                              .limit(1)
                              .getDocuments());
                          final List<DocumentSnapshot> documents = result.documents;
                          if(result.documents[0].data['username'] != snapshot.data.username) {
                            if (documents.length == 1) {
                              print("UserName Already Exits");
                              setState(() {
                                _userExist = documents.length == 1;
                              });
                            } else {
                              print("UserName is Available");
                              setState(() {
                                _userExist = documents.length == 1;
                              });
                            }
                          } else {
                            setState((){_userExist = false;});
                          }
                          if(_formKey.currentState.validate()){
                            if (!_userExist) {
                              await DatabaseService(key: user.uid)
                                  .updateUserData(
                                  _currentUsername ?? snapshot.data.username,
                                  snapshot.data.email,
                                  _currentBio ?? snapshot.data.bio,
                                  snapshot.data.isOnline);
                              Navigator.pop(context);
                            }else{
                              setState(() {
                                error = 'this username already exists';
                              });
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 50.0),
                  ],
                ),
              )
          ),
        ) : Loading();
      }
    );
  }
}
