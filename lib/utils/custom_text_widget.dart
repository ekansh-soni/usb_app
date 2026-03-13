
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/style_helper.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final FontStyle? fontStyle;

  const CustomTextWidget(
      {super.key, required this.text, this.fontWeight,  this.fontSize, this.color, this.textDecoration, this.fontStyle});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: StyleHelper.customStyle(
        fontWeight: fontWeight ?? FontWeight.w500,
        fontSize:   fontSize,
        color: color ?? AppColors.blackColor,
        textDecoration: textDecoration,
        fontStyle: fontStyle
    ));
  }
}
