import 'package:flutter/material.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:helpquest/shared/local_data.dart';

class Conversation extends StatefulWidget {
  final String chatRoomId;
  final String myName;
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
      appBar: AppBar(
        title: Text("123"),
      ),
      body: Container(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: chatMessageList(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
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
              const Color(0xff00fEF4),
              const Color(0xff2A75BC)
            ] : [
              const Color(0x1AFFFFFF),
              const Color(0x1AFFFFFf)
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
