import 'package:flutter/material.dart';
import 'package:helpquest/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:helpquest/models/user.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text('HelpQuest'),
          backgroundColor: Colors.grey[900],
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () async {
                  await _auth.signOut(user.uid);
                },
                icon: Icon(Icons.person),
                label: Text('logout'))
          ]
      ),
    );
  }
}
