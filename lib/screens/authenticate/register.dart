import 'package:flutter/material.dart';
import 'package:helpquest/services/auth.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/loading.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:helpquest/shared/helper_functions.dart';
class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';
  String username = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.purple[700],
          elevation: 0.0,
          title: Text('Register to HelpQuest'),
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: (){
                    widget.toggleView();
                  },
                  icon: Icon(Icons.person_outline),
                  label: Text('Sign in'))
            ]
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
                child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(hintText: 'Username'),
                        validator: (val) => val.isEmpty ? 'Enter an username' : null,
                        onChanged: (val){
                          setState(()=> username = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        validator: (val) => val.isEmpty ? 'Enter an email' : null,
                          onChanged: (val){
                            setState(()=> email = val);
                          }
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                          obscureText: true,
                          validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                          onChanged: (val){
                            setState(()=> password = val);
                          }
                      ),
                      SizedBox(height: 20.0),
                      RaisedButton(
                          color: Colors.pink[400],
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if(_formKey.currentState.validate()){
                              setState(()=> loading = true);
                              HelperFunctions.saveUserEmailSharedPreference(email);
                              HelperFunctions.saveUserNameSharedPreference(username);
                              HelperFunctions.saveUserLoggedInSharedPreference(true);
                              dynamic result = await _auth.registerWithEmailAndPassword(email, password, username);
                              if(result == null){
                                setState(() {
                                  error = 'please supply a valid email';
                                  loading = false;
                                  HelperFunctions.saveUserLoggedInSharedPreference(false);
                                });
                              }
                            }
                          }
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0)
                      )
                    ]
                )
            )
        )
    );
  }
}
