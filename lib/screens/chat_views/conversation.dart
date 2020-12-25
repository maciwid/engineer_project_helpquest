import 'package:flutter/material.dart';
import 'package:helpquest/screens/chat_views/message_tile.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';

class Conversation extends StatefulWidget {
  final String chatRoomId;
  final String myName;
  //final String username;
  Conversation(this.chatRoomId, this.myName);
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {

DatabaseService _databaseService = DatabaseService();
Stream chatMessagesStream;

TextEditingController messageController = new TextEditingController();

  Widget chatMessageList(){
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            return MessageTile(snapshot.data.documents[index].data["message"],snapshot.data.documents[index].data["sendBy" ]== widget.myName);
          },
        ) : Container();
      },
    );
  }
  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": widget.myName,
        "time" : DateTime.now().millisecondsSinceEpoch
      };
      messageController.text = "";
      _databaseService.addConversationMessages(widget.chatRoomId, messageMap);
    }
  }

  @override
  void initState() {
    _databaseService.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, "ChitChat"),
      body: Container(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: Container(
                  decoration: boxBackgroundDecoration,
                  child: chatMessageList()),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: boxBackgroundDecoration,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            decoration: textInputDecoration.copyWith(hintText: 'message...'),
                            controller: messageController,
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                const Color(0x36FFFFFF),
                                const Color(0x0FFbbbFFF)
                              ]
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: EdgeInsets.all(8),

                        child: GestureDetector(
                            onTap: (){
                              sendMessage();
                            },
                            child: Icon(Icons.send)
                        ),
                      )
                    ]
                ),
              ),
            )
          ],
        )
      )
    );
  }
}
