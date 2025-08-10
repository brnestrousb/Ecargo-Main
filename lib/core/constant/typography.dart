import 'package:flutter/material.dart';

class AppTextStyle {
  static const _fontFamily = 'PlusJakartaSans';

  static const headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
  );

  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamily,
  );

  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
  );
}
