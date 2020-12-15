import 'package:flutter/material.dart';
import 'package:helpquest/screens/chat_views/search.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),

      ),
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
