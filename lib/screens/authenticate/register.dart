import 'package:flutter/material.dart';
import 'package:helpquest/services/auth.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/loading.dart';
import 'package:helpquest/shared/constants.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
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
          backgroundColor: primaryColor2shade1,
          elevation: 5.0,
          title: Text('Register', style: mediumTextStyle),
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: (){
                    widget.toggleView();
                  },
                  icon: Icon(Icons.person_outline, color: primaryColor1,),
                  label: Text('Sign in', style: mediumTextStyle,))
            ]
        ),
        body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Container(
                  decoration: boxBackgroundDecoration,
                  padding: EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 50.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                          children: <Widget>[
                            SizedBox(height: 30),
                            Text("HelpQuest", style: logoTextStyle),
                            SizedBox(height: 20.0),
                            Container(
                              decoration: inputBoxDecoration,
                              child: TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Username',suffixIcon: Icon(Icons.person)),
                                validator: (val) =>
                                val.isEmpty
                                    ? 'Enter an username'
                                    : null,
                                onChanged: (val) {
                                  setState(() => username = val);
                                },
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              decoration: inputBoxDecoration,
                              child: TextFormField(
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Email', suffixIcon: Icon(Icons.mail)),
                                  validator: (val) =>
                                  val.isEmpty
                                      ? 'Enter an email'
                                      : null,
                                  onChanged: (val) {
                                    setState(() => email = val);
                                  }
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              decoration: inputBoxDecoration,
                              child: TextFormField(
                                  obscureText: true,
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Password', suffixIcon: Icon(Icons.lock_open)),
                                  validator: (val) =>
                                  val.length < 6
                                      ? 'Enter a password 6+ chars long'
                                      : null,
                                  onChanged: (val) {
                                    setState(() => password = val);
                                  }
                              ),
                            ),
                            SizedBox(height: 20.0),
                            RaisedButton(
                                child: Container(
                                  decoration: buttonDecoration,
                                  child: Text(
                                    'Register',
                                    style: mediumTextStyle,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() => loading = true);
                                    dynamic result = await _auth
                                        .registerWithEmailAndPassword(
                                        email, password, username);
                                    if (result == null) {
                                      setState(() {
                                        error = 'please supply a valid email';
                                        loading = false;
                                      });
                                    }
                                  }
                                }
                            ),
                            SizedBox(height: 12.0),
                            Text(
                                error,
                                style: TextStyle(color: Colors.red,
                                    fontSize: 14.0)
                            )
                          ]
                      )
                  )
              ),
            ),
          );

        }
        )
    );
  }
}
