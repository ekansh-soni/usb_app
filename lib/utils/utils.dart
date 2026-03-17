import 'package:flutter/material.dart';
import 'package:usb_app/utils/custom_text_widget.dart';

Widget commonRow(String value, value2){
  return Row(
    mainAxisAlignment: .spaceBetween,
    children: [
      Expanded(child: Text(value)),
      Expanded(child: CustomTextWidget(text:  value2,  textAlign: .end,)),
    ],
  );
}

Widget spaceHeight(double height){
  return SizedBox(height: height,);
}

Widget spaceWeight(double width){
  return SizedBox(width: width,);
}

String getDate(String dateTimeStr) {
  DateTime dt = DateTime.parse(dateTimeStr.replaceFirst(" ", "T"));
  return dt.toIso8601String().split("T")[0]; // 2026-01-29
}

String getTime(String dateTimeStr) {
  DateTime dt = DateTime.parse(dateTimeStr.replaceFirst(" ", "T"));
  return dt.toIso8601String().split("T")[1].split(".")[0]; // 13:09:00
}

String checkString(String val){
  return val.isEmpty ? "N/A" : val;
}