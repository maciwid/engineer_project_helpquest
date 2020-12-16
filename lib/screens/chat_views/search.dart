import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helpquest/models/user.dart';
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
  String username, email;
  QuerySnapshot searchSnapshot;
  initiateSearch(){
    _databaseService.getUserByUsername(searchTextEditingController.text)
        .then((val){
          setState(() {
            searchSnapshot = val;
          });
    });
  }
  ///create chatroom, send user to conversation screen, push replacement
  createChatRoom(){

  }
  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return SearchTile(
            username: searchSnapshot.documents[index].data["username"],
            email: searchSnapshot.documents[index].data["email"],);
        }): Container();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      decoration: textInputDecoration.copyWith(hintText: 'search username...'),
                    ),
                ),
                Container(
                  width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0x36FFFFFF),
                          const Color(0x0FFFFFFF)
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
          searchList()
        ]
      )
    );
  }
}

class SearchTile extends StatelessWidget {
  final String username;
  final String email;
  SearchTile({this.username, this.email});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username, ),
              Text(email, )
            ],
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30)
              ),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: FlatButton(
                  onPressed: (){

                  },
                    child: Text("Message"),
                ),
          )

        ],
      )
    );
  }
}

getChatRoomID(String a, String b){
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0))
    return "$b\_$a";
  else
    return "$a\_$b";
}