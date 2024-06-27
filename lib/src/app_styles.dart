import 'package:flutter/material.dart';

class AppStyles {
  static const Color primaryColor = Color.fromARGB(255, 17, 99, 151);
  static const Color backgroundColor = Colors.white;

  // AppBar styles
  static const TextStyle appBarUserNameStyle = TextStyle(
    color: primaryColor,
    fontSize: 20,
  );

  static const TextStyle appBarCompanyStyle = TextStyle(
    color: primaryColor,
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle appBarSubtitleTextStyle = TextStyle(
    color: primaryColor,
    fontSize: 16,
  );

  static const BoxDecoration appBarDecoration = BoxDecoration(
    color: Colors.white,
  );

  static const IconThemeData iconTheme = IconThemeData(
    color: primaryColor,
  );

  static const double topBarIconSize = 30.0;

  // Headline style
  static const TextStyle headlineStyle = TextStyle(
    color: primaryColor,
    fontSize: 24,
  );

  // Card styles
  static const TextStyle cardTitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle cardSubtitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
  );

  static const Color cardBackgroundColor = primaryColor;
  static const double cardElevation = 4.0; // Add cardElevation property
  static const double cardIconSize = 45.0; // Add cardIconSize property

  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);

  static const double cardHeight = 90.0;

  static final ShapeBorder cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  );

  static const Alignment cardContentAlignment = Alignment.centerLeft;
  static const EdgeInsets cardContentPadding = EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0);

  // Bottom AppBar styles
  static const BottomAppBarTheme bottomAppBarTheme = BottomAppBarTheme(
    shape: CircularNotchedRectangle(),
    color: Colors.white,
  );

  static const IconThemeData bottomIconTheme = IconThemeData(
    color: Colors.black,
    size: 50.0,
  );

  // Custom Icon styles
  static const IconThemeData greenCheckIcon = IconThemeData(
    color: Colors.green,
    size: 30.0,
  );

  static const IconThemeData redDeleteIcon = IconThemeData(
    color: Colors.red,
    size: 30.0,
  );

  static const IconThemeData orangeEditIcon = IconThemeData(
    color: Colors.orange,
    size: 30.0,
  );
}
