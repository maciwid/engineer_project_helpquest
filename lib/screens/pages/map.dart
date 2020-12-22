import 'package:flutter/material.dart';
import 'package:helpquest/shared/constants.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context, "Map"),
      body: Container(
        decoration: boxBackgroundDecoration,
      )
    );
  }
}
