import 'package:flutter/material.dart';
import 'package:helpquest/models/quest.dart';
import 'package:helpquest/models/user.dart';
import 'package:helpquest/screens/quest_views/quest_form.dart';
import 'package:helpquest/services/chat_service.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:helpquest/shared/loading.dart';
import 'package:provider/provider.dart';


class QuestDetails extends StatefulWidget {
  final String questID;
  QuestDetails(this.questID);
  @override
  _QuestDetailsState createState() => _QuestDetailsState();
}

class _QuestDetailsState extends State<QuestDetails> {
 ChatService _chatService = ChatService();
  void _showEditQuestPanel(Quest quest){
    showModalBottomSheet(context: context, builder: (context){
      return QuestFormEdit(quest);
    },  isScrollControlled:true);
  }
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);


    return StreamBuilder<Quest>(
        stream: DatabaseService(key: widget.questID).quest,
        builder: (context, snapshot) {
          return (snapshot.hasData) ? StreamBuilder<UserData>(
            stream: DatabaseService(key: user.uid).userData,
            builder: (context, snapshot1) {
              return (snapshot1.hasData) ? Scaffold(
                  appBar: AppBar(
                      title: Text('Quest details',
                          style:  mediumTextStyle),
                      backgroundColor: primaryColor2shade1,
                      actions: <Widget>[
                        Visibility(
                          visible: user.uid == snapshot.data.employerID,
                          child: FlatButton.icon(
                              onPressed: (){
                                if(user.uid == snapshot.data.employerID)
                                  _showEditQuestPanel(snapshot.data);
                              },
                              icon: Icon(
                                  Icons.settings,
                                  color: Color.fromRGBO(255, 95, 155, 1)),
                              label: Text("Edit", style: TextStyle(
                                  color: Color.fromRGBO(255, 95, 155, 1)),
                              )),
                        )
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
                              Text("${snapshot.data.title}", style: mediumTextStyle,),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              Text("Status:  ", style: simpleTextStyle),
                              Text("${snapshot.data.status}", style: mediumTextStyle,),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              Text("Employer: ", style: simpleTextStyle),
                              Text(snapshot.data.empUserName, style: mediumTextStyle,),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              Text("Category: ", style: simpleTextStyle),
                              Text(snapshot.data.category, style: mediumTextStyle,),
                            ],
                          ),
                          Visibility(
                              visible: snapshot.data.region != null,
                              child: SizedBox(height: 20.0)),
                          Visibility(
                            visible: snapshot.data.region != null,
                            child: Row(
                              children: [
                                Text("Region: ", style: simpleTextStyle),
                                Text(snapshot.data.region ?? "", style: mediumTextStyle,),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              Text("Description: ", style: simpleTextStyle),
                              Flexible(child: Text(snapshot.data.description, style: mediumTextStyle,)),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              Text("Prize: ", style: simpleTextStyle),
                              Text("${snapshot.data.prize} credits", style: mediumTextStyle,),
                            ],
                          ),
                          SizedBox(height: 40.0),
                          Visibility(
                            visible: (snapshot.data.employerID != user.uid),
                            child: Align(
                              alignment: Alignment.center,
                              child: RaisedButton(
                                color: Colors.pink[400],
                                onPressed: (){
                                  _chatService.createChatRoomAndStartChat(
                                      snapshot.data.empUserName, snapshot1.data.username, context
                                      );
                                },
                                child: Text("Go to a chat with an employer", style: detailsTextStyle,),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              ) : Loading();
            }
          ) : Loading();
        }
    );



  }
}
