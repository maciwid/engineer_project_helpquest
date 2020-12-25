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
 DatabaseService _databaseService = DatabaseService();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Text("${widget.quest.title}", style: mediumTextStyle,),
                    SizedBox(height: 20.0),
                    Text("Employer: ${snapshot.data.username}", style: mediumTextStyle,),
                    SizedBox(height: 20.0),
                    Text("Category: ${widget.quest.category}", style: mediumTextStyle,),
                    SizedBox(height: 20.0),
                    Text(widget.quest.description, style: mediumTextStyle,),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      onPressed: (){
                       // _chatService.createChatRoomAndStartChat(
                           // _databaseService.getUserByUid(widget.quest.employerID).then((doc) => return), myName, context
                       //     );
                      },
                      child: Text("Go to chat with employer"),
                    )
                  ],
                ),
              )
          );
        }
    );



  }
}
