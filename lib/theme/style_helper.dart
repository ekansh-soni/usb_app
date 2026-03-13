
import 'package:flutter/material.dart';

const String bold = 'MulishBold';
const String semiBold = 'MulishSemiBold';
const String medium = 'MulishMedium';
const String regular = 'MulishRegular';

class StyleHelper {


  static TextStyle customStyle(
      {String? family,
      Color? color,
      double? fontSize,
      FontWeight?  fontWeight,
      TextDecoration? textDecoration, FontStyle? fontStyle}) {
    return TextStyle(
      fontFamily: family ,
      color: color  ,
      fontSize: fontSize  ,
      decoration: textDecoration,
      fontWeight: fontWeight,
      fontStyle: fontStyle
    );
  }
}
