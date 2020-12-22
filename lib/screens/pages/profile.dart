import 'package:flutter/material.dart';
import 'package:helpquest/services/auth.dart';
import 'package:helpquest/shared/constants.dart';
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
          title: Text('Your Profile',
          style: titleTextStyle),
          backgroundColor: primaryColor2shade1,
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () async {
                  await _auth.signOut(user.uid);
                },
                icon: Icon(Icons.person,
                    color: primaryColor1),

                label: Text('logout', style: mediumTextStyle,))
          ]

      ),
        body: Container(
          decoration: boxBackgroundDecoration,
        )
    );
  }
}
