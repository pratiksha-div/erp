import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Utils {
  // Standard navigation method, modified to return a result
  static Future<T?> navigateTo<T>(BuildContext context, var route) {
    return Navigator.push<T>(
      context,
      CupertinoPageRoute(builder: (context) => route),
    );
  }

  static navigateRemoveAll(BuildContext context, var route) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => route),
        (Route<dynamic> route) => false);
  }

}
