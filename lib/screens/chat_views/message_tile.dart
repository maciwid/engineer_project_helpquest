import 'package:flutter/material.dart';
import 'package:helpquest/shared/constants.dart';


class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSendByMe ? [
                primaryColor3,
                primaryColor1
              ] : [
                primaryColor3,
                 primaryColor2,
              ],
            ),
            borderRadius: isSendByMe ?
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ):
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)
            )
        ),
        child: Text(message, style: TextStyle(
            color: Colors.black,
            fontSize: 17
        )),
      ),
    );
  }
}
