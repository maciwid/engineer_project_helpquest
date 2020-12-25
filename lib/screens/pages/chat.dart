import 'package:flutter/material.dart';
import 'package:helpquest/models/user.dart';
import 'package:helpquest/screens/chat_views/chat_rooms_tile.dart';
import 'package:helpquest/screens/chat_views/search.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:helpquest/screens/chat_views/conversation.dart';
import 'package:provider/provider.dart';
class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  DatabaseService _databaseService = DatabaseService();
  Stream chatRoomsStream;

  Widget chatRoomList(myName){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return ChatRoomsTile(
                snapshot.data.documents[index].data["chatRoomID"]
                    .toString().replaceAll("_", "")
                    .replaceAll(myName, " "),
                  snapshot.data.documents[index].data["chatRoomID"]
              );

        }) : Container();
      }
    );
  }

 void getChatRooms(myName){
   _databaseService.getChatRooms(myName).then((value){
     setState(() {
       chatRoomsStream = value;
     });
   });
 }
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    getChatRooms(userData.username);

    return Scaffold(
      appBar: appBarMain(context, "Chat"),

      body: Container(
          decoration: boxBackgroundDecoration,
          child: chatRoomList(userData.username)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor2shade1,
        heroTag: "searchBtn",
      child: Icon(Icons.search),
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => SearchScreen()
        ));
      },
    ),
    );
  }
}
