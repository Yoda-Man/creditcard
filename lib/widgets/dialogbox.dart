import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

Widget dialogbox(
  BuildContext context,
  String title,
  String errorMsg,
) {
  return Flushbar(
    title: title,
    titleColor: Colors.lightBlueAccent,
    message: errorMsg,
    messageColor: Colors.lightBlueAccent,
    icon: const Icon(
      Icons.info_sharp,
      size: 28.0,
      color: Color(0xFF100887),
    ),
    isDismissible: true,
    shouldIconPulse: false,
    backgroundColor: const Color(0xFF100887),
    flushbarPosition: FlushbarPosition.TOP,
    duration: const Duration(seconds: 10),
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(16),
    borderColor: Colors.lightBlueAccent,
    padding: const EdgeInsets.only(left: 22, top: 10, bottom: 10),
  )..show(context);
}
