import 'package:flutter/material.dart';
import 'package:helpquest/screens/chat_views/chat_rooms_tile.dart';
import 'package:helpquest/screens/chat_views/search.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:helpquest/screens/chat_views/conversation.dart';
import 'package:helpquest/shared/local_data.dart';
class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  DatabaseService _databaseService = DatabaseService();
  Stream chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return ChatRoomsTile(
                snapshot.data.documents[index].data["chatRoomID"]
                    .toString().replaceAll("_", "")
                    .replaceAll(LocalData.myName, " "),
                  snapshot.data.documents[index].data["chatRoomID"]
              );

        }) : Container();
      }
    );
  }

 void getChatRooms(){
   _databaseService.getChatRooms(LocalData.myName).then((value){
     setState(() {
       chatRoomsStream = value;
     });
   });
 }
  @override
  Widget build(BuildContext context) {
    getChatRooms();

    return Scaffold(
      appBar: appBarMain(context, "Chat"),

      body: Container(
          decoration: boxBackgroundDecoration,
          child: chatRoomList()),
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
