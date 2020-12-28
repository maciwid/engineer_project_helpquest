import 'package:flutter/material.dart';
import 'package:helpquest/screens/chat_views/conversation.dart';
import 'package:helpquest/services/database.dart';

class ChatService{
  DatabaseService _databaseService = DatabaseService();

  createChatRoomAndStartChat(String userName, String myName, BuildContext context){
    List<String> users = [userName, myName];
    String chatRoomId = getChatRoomID(userName, myName);
    _databaseService.getChatRoomsById(chatRoomId).then((value){
     // if(value == null)
        _databaseService.createChatRoom(chatRoomId, users);
    });
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => Conversation(chatRoomId, myName, userName)
    ));
  }

  getChatRoomID(String a, String b){
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0))
      return "$b\_$a";
    else
      return "$a\_$b";
  }
}