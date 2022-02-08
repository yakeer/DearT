import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    backgroundColor: Colors.white,
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.blue,
    ),
  );
  // static final dark = ThemeData.dark().copyWith(
  //   backgroundColor: Colors.black,
  //   buttonTheme: const ButtonThemeData(
  //     buttonColor: Colors.red,
  //   ),
  // );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    // backgroundColor: ,
    appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade900),
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.grey.shade900,
    fontFamily: 'Roboto',
  );
}
