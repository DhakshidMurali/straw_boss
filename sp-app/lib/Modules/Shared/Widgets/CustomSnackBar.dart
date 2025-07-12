import 'package:flutter/material.dart';
import 'package:sp_app/constant.dart';

SnackBar customSnackBar({required String content}) {
  return SnackBar(
    backgroundColor: kPrimary,
    content: Text(
      content,
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
