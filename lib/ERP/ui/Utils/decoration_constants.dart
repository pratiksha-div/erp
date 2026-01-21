import 'package:flutter/cupertino.dart';

import 'colors_constants.dart';

class DecorationConstants {
  static var decorationGradient = BoxDecoration(
      border: Border.all(
        color: ColorConstants.primary,
      ),
    gradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ColorConstants.primary, ColorConstants.secondary],
  ));
}
