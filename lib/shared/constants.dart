import 'package:flutter/material.dart';

const primaryColor1 =  Color.fromRGBO(250, 47, 124, 1);
const primaryColor1shade =  Color.fromRGBO(255, 95, 155, 1);
const primaryColor2shade = Color.fromRGBO(8, 18, 160, 1);
const primaryColor2 = Color.fromRGBO(20, 74, 184, 1);
const primaryColor2shade1 =Color.fromRGBO(0, 4, 68, 1);
const primaryColor3 =  Color.fromRGBO(238, 255, 142, 1);

const textInputDecoration = InputDecoration(
  filled: false,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor2, width: 2.0)
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor1, width: 2.0)
  ),
);

var inputBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(3),
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          primaryColor2shade,
          primaryColor2,
          primaryColor1shade
        ]
    )
);

var buttonDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(3),
    gradient: LinearGradient(colors: [
      primaryColor2shade1,
      Colors.black
    ]
    )
);
const boxBackgroundDecoration = BoxDecoration(
  gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    colors: [
      Colors.black,
      primaryColor2shade1,
      primaryColor2shade,
      primaryColor1
    ]
  )
);

Widget appBarMain(BuildContext context, String title) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(
          color: primaryColor1,
          fontSize: 22,
          fontFamily: 'CruiserFortress3d'
      ),
      ),
    backgroundColor: primaryColor2shade1,
    elevation: 5.0,
    centerTitle: true,
  );
}

const simpleTextStyle = TextStyle(
  color: primaryColor2shade1,
  fontSize: 16,
  fontFamily: 'Comfortaa',
);

const mediumTextStyle = TextStyle(
  color: primaryColor1shade,
  fontSize: 17,
  fontFamily: 'Comfortaa',
);

const titleTextStyle = TextStyle(
      color: primaryColor1,
      fontSize: 22,
      fontFamily: 'CruiserFortress3d'

);

const logoTextStyle = TextStyle(
    color: primaryColor1,
    fontSize: 30,
    fontFamily: 'Thunderstrike'

);