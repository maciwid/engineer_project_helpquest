import 'package:flutter/material.dart';
import 'package:helpquest/screens/wrapper.dart';
import 'package:helpquest/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:helpquest/shared/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: appTheme,
        debugShowCheckedModeBanner: false,
         home: Wrapper()
      ),
    );
  }
}
