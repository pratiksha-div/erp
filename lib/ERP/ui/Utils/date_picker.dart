import 'package:flutter/material.dart';

import 'colors_constants.dart';

Future<DateTime?> showAppDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  return showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate ?? DateTime(2000),
    lastDate: lastDate ?? DateTime(DateTime.now().year + 5),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.grey.withOpacity(.6),
          colorScheme: ColorScheme.light(
            primary: ColorConstants.primary,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(
              color: ColorConstants.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          datePickerTheme: DatePickerThemeData(
            dividerColor: Colors.grey.withOpacity(.6),
            dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return ColorConstants.primary;
              }
              return null;
            }),
            dayForegroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.white;
              }
              return Colors.black;
            }),
            dayShape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: ColorConstants.primary,
            ),
          ),
        ),
        child: child!,
      );
    },
  );
}
