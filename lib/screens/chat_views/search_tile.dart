import 'package:flutter/material.dart';
import 'package:helpquest/shared/constants.dart';

class SearchTile extends StatelessWidget {
  final String username;
  final String email;
  final Function startChat;
  SearchTile({this.username, this.email, this.startChat});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username, ),
                Text(email, )
              ],
            ),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(colors: [
                    primaryColor1,
                    primaryColor1shade
                  ])
              ),

              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: FlatButton(
                onPressed: (){
                  startChat();
                },
                child: Text("Message"),
              ),
            )
          ],
        )
    );
  }
}
