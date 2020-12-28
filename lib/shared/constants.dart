import 'package:flutter/material.dart';

const primaryColor1 =  Color.fromRGBO(250, 47, 124, 1);
const primaryColor1shade =  Color.fromRGBO(255, 95, 155, 1);
const primaryColor2shade = Color.fromRGBO(8, 18, 160, 1);
const primaryColor2 = Color.fromRGBO(20, 74, 184, 1);
const primaryColor2shade1 =Color.fromRGBO(0, 4, 68, 1);
const primaryColor3 =  Color.fromRGBO(238, 255, 142, 1);

var appTheme = ThemeData(
  primaryColor: primaryColor2,
  accentColor: primaryColor1,
  fontFamily: "Comfortaa",
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: primaryColor1, fontFamily: 'Comfortaa'),
      hintStyle: TextStyle(color: primaryColor1, fontSize: 12, fontFamily: 'Comfortaa'),
    ),
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontFamily: 'Thunderstrike', color: primaryColor1),
    headline6: TextStyle(fontSize: 36.0, fontFamily: 'CruiserFortress3d', color: primaryColor1),
    bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Comfortaa', color: primaryColor1shade),
  ),
);

const textInputDecoration = InputDecoration(
  hintStyle: simpleTextStyle,
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
  color: primaryColor1,
  fontSize: 14,
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
    fontSize: 48,
    fontFamily: 'Thunderstrike'

);