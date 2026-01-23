import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(String inputDate) {
  try {
    // Parse the input (expects dd/MM/yyyy)
    DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(inputDate);

    // Format to desired output → e.g., 9 July 2025
    String formatted = DateFormat("d MMMM yyyy").format(parsedDate);
    return formatted;
  } catch (e) {
    print("Date parsing error: $e");
    return inputDate; // fallback to original if invalid
  }
}
// String formatEntryDate(String inputDate) {
//       String input = "February, 08 2025 00:00:00 +0530";
//       DateTime date = DateFormat("MMMM, dd yyyy HH:mm:ss Z").parse(inputDate);
//       String formatted = DateFormat("d MMM yyyy").format(date);
//       return formatted;
// }

String formatEntryDate(String inputDate) {
  if (inputDate.isEmpty) return "-";

  DateTime date;

  try {
    // Case 1: "February, 08 2025 00:00:00 +0530"
    date = DateFormat(
      "MMMM, dd yyyy HH:mm:ss Z",
    ).parse(inputDate);
  } catch (_) {
    try {
      // Case 2: ISO / DateTime.toString()
      date = DateTime.parse(inputDate);
    } catch (_) {
      return "-";
    }
  }

  return DateFormat("d MMM yyyy").format(date);
}


String formatMachineDate(String inputDate) {
  if (inputDate == null || inputDate.trim().isEmpty) return "--";
  final date = DateFormat('dd/MM/yyyy').parse(inputDate);
  return DateFormat('d MMM yyyy').format(date);
}

String formatTimeWithSpace(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}


String dateTimeFormat(DateTime selectedDate, TimeOfDay selectedTime) {
  // Combine date + time
  final DateTime combinedDateTime = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    selectedTime.hour,
    selectedTime.minute,
  );

  // Format dynamically
  // final formatted = DateFormat('MM-dd-yyyy hh:mm').format(combinedDateTime);
  final formatted = DateFormat('yyyy-MM-dd hh:mm').format(combinedDateTime);
  return formatted;
}