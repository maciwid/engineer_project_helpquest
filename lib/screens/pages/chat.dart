import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: Text('Chat'),

      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
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
              color: Colors.blue,
              borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}")
            ),
            SizedBox(width: 8,),
            Text(userName, style: mediumTextStyle(),)
          ],
        )
      ),
    );
  }
}
