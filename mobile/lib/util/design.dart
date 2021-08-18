import 'package:flutter/material.dart';

class Cores {
  static Color primary = Color(0xff264653);
  static Color secondary = Color(0xff2A9D8F);
  static Color tertiery = Color(0xffF4A261);

  static Color success = Color(0xff61B04B);
  static Color danger = Color(0xffE76F51);
  static Color alert = Color(0xffE9C46A);

  static const int _greyPrimaryValue = 0xFF9E9E9E;
  static const MaterialColor grey = MaterialColor(
    _greyPrimaryValue,
    <int, Color>{
      50: Color(0xFFFAFAFA),
      100: Color(0xFFF5F5F5),
      200: Color(0xFFEEEEEE),
      300: Color(0xFFE0E0E0),
      400: Color(0xFFBDBDBD),
      500: Color(_greyPrimaryValue),
      600: Color(0xFF757575),
      700: Color(0xFF616161),
      800: Color(0xFF424242),
      900: Color(0xFF212121),
    },
  );
}

main(List<String> args) {}
