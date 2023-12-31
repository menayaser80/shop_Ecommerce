import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppColors {
  static const Color lightScaffoldColor = Colors.white;
  static const Color lightPrimary = Color(0xFF181059);
  static const Color lightCardColor = Color.fromARGB(106, 250, 250, 250);
  static const Color darkScaffoldColor = Color.fromARGB(255, 9, 3, 27);
  static const Color darkPrimary = Color.fromARGB(255, 94, 75, 236);
}
void navigateTo(context,Widget)=>Navigator.push(context, MaterialPageRoute(
  builder:(context)=>Widget,
));
void navigateandFinish(context,Widget)=>Navigator.pushAndRemoveUntil(context,MaterialPageRoute(
  builder: (context)=>Widget,
),
      (route)
  {
    return false;
  },

);
void showToast({
  required String message,
  Color color = Colors.blueAccent,
  Color txtColor = Colors.black,
}) =>
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: color,
      textColor: txtColor,
      fontSize: 16.0,
    );