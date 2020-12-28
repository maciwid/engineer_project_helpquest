import 'package:flutter/material.dart';
import 'package:helpquest/models/quest.dart';
import 'package:helpquest/models/user.dart';
import 'package:helpquest/screens/quest_views/quest_form.dart';
import 'package:helpquest/services/chat_service.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:provider/provider.dart';


class QuestFormView extends StatefulWidget {
  final Quest quest;
  QuestFormView(this.quest);
  @override
  _QuestFormViewState createState() => _QuestFormViewState();
}

class _QuestFormViewState extends State<QuestFormView> {
  bool enableEdit = false;
 ChatService _chatService = ChatService();
  void _showEditQuestPanel(){
    showModalBottomSheet(context: context, builder: (context){
      return QuestFormEdit(widget.quest);
    },  isScrollControlled:true);
  }
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    if(user.uid == widget.quest.employerID)
      setState((){enableEdit = true;});

    return StreamBuilder<UserData>(
        stream: DatabaseService(key: widget.quest.employerID).userData,
        builder: (context, snapshot) {
          return StreamBuilder<UserData>(
            stream: DatabaseService(key: user.uid).userData,
            builder: (context, snapshot1) {
              return Scaffold(
                  appBar: AppBar(
                      title: Text('Quest details',
                          style:  mediumTextStyle),
                      backgroundColor: primaryColor2shade1,
                      actions: <Widget>[
                        FlatButton.icon(
                            onPressed: (){
                              if(enableEdit)
                                _showEditQuestPanel();
                            },
                            icon: Icon(
                                Icons.settings,
                                color: (enableEdit) ? Color.fromRGBO(255, 95, 155, 1) : Color.fromRGBO(255, 95, 155, 0)),
                            label: Text("Edit", style: TextStyle(
                                color: (enableEdit) ? Color.fromRGBO(255, 95, 155, 1) : Color.fromRGBO(255, 95, 155, 0)),
                            ))
                      ]
                  ),

                  body: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: boxBackgroundDecoration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0 , horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              Text("Quest:  ", style: simpleTextStyle),
                              Text("${widget.quest.title}", style: mediumTextStyle,),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              Text("Employer: ", style: simpleTextStyle),
                              Text(snapshot.data.username, style: mediumTextStyle,),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              Text("Category: ", style: simpleTextStyle),
                              Text(widget.quest.category, style: mediumTextStyle,),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              Text("Description: ", style: simpleTextStyle),
                              Text(widget.quest.description, style: mediumTextStyle,),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              Text("Prize: ", style: simpleTextStyle),
                              Text("${widget.quest.prize} credits", style: mediumTextStyle,),
                            ],
                          ),
                          SizedBox(height: 40.0),
                          Align(
                            alignment: Alignment.center,
                            child: RaisedButton(
                              color: Colors.pink[400],
                              onPressed: (){
                                _chatService.createChatRoomAndStartChat(
                                    snapshot.data.username, snapshot1.data.username, context
                                    );
                              },
                              child: Text("Go to chat with employer"),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              );
            }
          );
        }
    );



  }
}
