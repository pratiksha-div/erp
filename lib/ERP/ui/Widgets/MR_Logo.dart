import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Utils/colors_constants.dart';
import '../Utils/images_constants.dart';

Widget mr_logo()
{
  return Container(
    width: 80,
    height: 80,
    padding: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withOpacity(0.15),
      border: Border.all(color: ColorConstants.primary.withOpacity(0.2), width: 1),
    ),
    child: Center(
      child: Image.asset(
        ImageConstants.logoURl,
      ),
    ),
  );
}

