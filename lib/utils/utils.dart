import 'package:flutter/material.dart';

Widget commonRow(String value, value2){
  return Row(
    mainAxisAlignment: .spaceBetween,
    children: [
      Text(value),
      Text(value2),
    ],
  );
}

Widget spaceHeight(double height){
  return SizedBox(height: height,);
}

Widget spaceWeight(double width){
  return SizedBox(width: width,);
}