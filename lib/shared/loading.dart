import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:helpquest/shared/constants.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxBackgroundDecoration,
      child: Center(
        child: SpinKitDoubleBounce(
          color: primaryColor1,
          size: 50.0,
        )
      )
    );
  }
}
