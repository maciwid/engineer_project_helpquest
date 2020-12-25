import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helpquest/models/user.dart';
import 'package:helpquest/screens/chat_views/conversation.dart';
import 'package:helpquest/screens/chat_views/search_tile.dart';
import 'package:helpquest/services/chat_service.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:helpquest/services/database.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchTextEditingController = new TextEditingController();
  DatabaseService _databaseService = DatabaseService();
  ChatService _chatService = ChatService();
  String username = "";
  QuerySnapshot searchSnapshot;
  initiateSearch(){
    _databaseService.getUserByUsername(searchTextEditingController.text)
        .then((val){
          setState(() {
            searchSnapshot = val;
          });
    });
  }


  Widget searchList(String myName){
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return SearchTile(
              username: searchSnapshot.documents[index].data["username"],
              email: searchSnapshot.documents[index].data["email"],
              startChat: () {
                print("yooo $myName");
                _chatService.createChatRoomAndStartChat(username, myName, context);
              });
        }): Container();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);


        return StreamBuilder<UserData>(
          stream: DatabaseService(key: user.uid).userData,
          builder: (context, snapshot) {
            final String myName = snapshot.data.username;
            return Scaffold(
              appBar: appBarMain(
                context,
                "Search"
              ),
              body: Container(
                decoration: boxBackgroundDecoration,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                                controller: searchTextEditingController,
                                decoration: textInputDecoration.copyWith(hintText: 'search username...'),
                                  onChanged: (val){
                                    setState(()=> username = val);
                                  }
                              ),
                          ),
                          SizedBox(width: 16,),
                          Container(
                            width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FaaFFF),
                                    const Color(0x0FFbbbFFF)
                                  ]
                                ),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              padding: EdgeInsets.all(8),

                              child: GestureDetector(
                                onTap: (){
                                  initiateSearch();
                                },
                                  child: Icon(Icons.search)
                              ),
                          )
                        ]
                      ),
                    ),
                    searchList(myName)
                  ]
                ),
              )
            );
          }
        );
      }

  }



