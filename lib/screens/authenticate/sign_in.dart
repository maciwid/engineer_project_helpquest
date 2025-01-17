import 'package:flutter/material.dart';
import 'package:helpquest/services/auth.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:helpquest/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  bool loading = false;
  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor2shade1,
        elevation: 5.0,
        title: Text('Sign in', style: mediumTextStyle,),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: (){
                  widget.toggleView();
                },
                icon: Icon(Icons.person_add, color: primaryColor1,),
                label: Text('Register', style: mediumTextStyle,))
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
                            SizedBox(height: 20.0),
                            Text("HelpQuest", style: logoTextStyle),
                            SizedBox(height: 40.0),
                            Container(
                              decoration: inputBoxDecoration,
                              child: TextFormField(
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'email...', suffixIcon: Icon(Icons.mail)),
                                  validator: (val) =>
                                  val.isEmpty
                                      ? 'Enter an email'
                                      : null,
                                  onChanged: (val) {
                                    setState(() => email = val);
                                  },
                                  style: mediumTextStyle,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              decoration: inputBoxDecoration,
                              child: TextFormField(
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'password...', suffixIcon: Icon(Icons.lock_open)),
                                  obscureText: true,
                                  validator: (val) =>
                                  val.length < 6
                                      ? 'Enter a password 6+ chars long'
                                      : null,
                                  onChanged: (val) {
                                    setState(() => password = val);
                                  },
                                style: mediumTextStyle,
                              ),
                            ),
                            SizedBox(height: 40.0),
                            RaisedButton(
                              color: primaryColor2,
                                child: Container(
                                  //padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                  child: Text(
                                    'Sign in',
                                    style: mediumTextStyle,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() => loading = true);
                                    dynamic result = await _auth
                                        .signInWithEmailAndPassword(
                                        email, password);
                                    print("this is printed");
                                    if (result == null) {
                                      setState(() => error =
                                      'Could not sign in with these credentials');
                                      loading = false;
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
                  ,
                ),
              )

          );
        })
    );
  }
}
