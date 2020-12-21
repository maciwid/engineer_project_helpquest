import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0)
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepPurple, width: 2.0)
  ),
);


TextStyle simpleTextStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 16
  );
}

TextStyle mediumTextStyle(){
  return TextStyle(
    color: Colors.black,
    fontSize: 17
  );
}