import 'package:flutter/material.dart';
import '../Utils/colors_constants.dart';

Widget sideGradientBar({double ht=35}) {
  return Container(
    height: ht,
    width: 5,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          ColorConstants.primary,
          ColorConstants.secondary,
        ],
      ),
    ),
  );
}