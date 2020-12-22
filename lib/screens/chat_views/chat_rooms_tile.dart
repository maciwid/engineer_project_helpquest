import 'package:flutter/material.dart';
import 'package:helpquest/screens/chat_views/conversation.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:helpquest/shared/local_data.dart';


class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomsTile(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Conversation(chatRoomId, LocalData.myName))
        );
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: primaryColor1,
                      borderRadius: BorderRadius.circular(40)
                  ),
                  child: Text("${userName.substring(0,1).toUpperCase()}")
              ),
              SizedBox(width: 8,),
              Text(userName, style: mediumTextStyle,)
            ],
          )
      ),
    );
  }
}
