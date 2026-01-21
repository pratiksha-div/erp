
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utils/colors_constants.dart';

Future<TimeOfDay?> pickTimeDialogue(BuildContext context)
{
  return  showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: ColorConstants.primary,
            tertiary: ColorConstants.primary,
            secondary: ColorConstants.primary,
            onPrimary: Colors.white,
            onSurface: ColorConstants.primary,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: ColorConstants.primary,
              textStyle: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          timePickerTheme: TimePickerThemeData(
            backgroundColor: Colors.white,
            hourMinuteTextStyle: GoogleFonts.poppins(
              fontSize: 25,
              color: ColorConstants.primary,
              fontWeight: FontWeight.bold,
            ),
            hourMinuteTextColor: ColorConstants.primary,
            dialBackgroundColor: Colors.white.withOpacity(.2),
            inputDecorationTheme: InputDecorationTheme(
              hintStyle: GoogleFonts.poppins(
                color: ColorConstants.primary.withOpacity(0.6),
              ),
              labelStyle: GoogleFonts.poppins(
                color: ColorConstants.primary,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.primary),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.primary),
              ),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
}

