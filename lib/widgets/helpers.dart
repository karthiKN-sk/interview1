import 'package:flutter/material.dart';
import 'package:themebykarthi/themebykarthi.dart';

isSuccessSnackBar(
  BuildContext context, {
  required String message,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    showSimpleSnackbar(
      backgroundColor: Colors.green,
      text: message.toTitleCaze(),
      textcolor: Colors.white,
      time: 1,
    ),
  );
}

isErrorSnackBar(
  BuildContext context, {
  required String message,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    showSimpleSnackbar(
      backgroundColor: Colors.red,
      text: message.toTitleCaze(),
      textcolor: Colors.white,
      time: 1,
    ),
  );
}

showSimpleSnackbar({
  required Color backgroundColor,
  required String text,
  required Color textcolor,
  required int time,
}) {
  return SnackBar(
    margin: EdgeInsets.only(
      right: AppSize.s5!,
      left: AppSize.s5!,
      bottom: AppSize.s5!,
    ),
    content: Text(
      text,
      style: TextStyle(color: textcolor),
    ),
    backgroundColor: backgroundColor,
    duration: Duration(seconds: time),
    behavior: SnackBarBehavior.floating,
  );
}
