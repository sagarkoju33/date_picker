import 'dart:developer';

import 'package:_date_picker_calendar/calendar_view/calendar_view.dart';
import 'package:_date_picker_calendar/helper/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final datePicker = TextEditingController();
  final datePicker1 = TextEditingController();
  final String inputFieldLabelText = "dd-MM-yyyy";
  final String inputFieldLabelText1 = "yyyy-MM-dd";
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          counterStyle: TextStyle(color: Colors.red.shade600),
          labelStyle: TextStyle(color: Colors.black),
          hintStyle: TextStyle(color: Colors.grey.shade400),
        ),
      ),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Selected Date",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomDatePickerScreen(
                dateController: datePicker,
                hintText: inputFieldLabelText,
                labelText: inputFieldLabelText,
                inputFieldLabelText: inputFieldLabelText,
                inputFieldHintText: inputFieldLabelText,
                showAllDate: true,

                inputFieldOnChanged: (text) {
                  _onTextFieldChanged(text, isYearFirst: false);
                },
                inputFieldCustomValidation: (text) {
                  customValidation(text, isYearFirst: false);
                },
                onChanged: (text) {
                  log("Selected date: $text");
                },
                onOkButtonClicked: () {
                  textfieldManuallyOnPressed(isYearFirst: false);
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomDatePickerScreen(
                dateController: datePicker1,
                hintText: inputFieldLabelText1,
                labelText: inputFieldLabelText1,
                inputFieldLabelText: inputFieldLabelText1,
                inputFieldHintText: inputFieldLabelText1,
                showAllDate: true,

                inputFieldOnChanged: (text) {
                  _onTextFieldChanged(text, isYearFirst: true);
                },
                inputFieldCustomValidation: (text) {
                  customValidation(text, isYearFirst: true);
                },
                onChanged: (text) {
                  log("Selected date: $text");
                },
                onOkButtonClicked: () {
                  textfieldManuallyOnPressed(isYearFirst: true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTextFieldChanged(String date, {bool isYearFirst = true}) {
    String text = date.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length > 8) {
      text = text.substring(0, 8);
    }

    String formatted = '';

    if (isYearFirst) {
      // yyyy-MM-dd format
      if (text.length >= 4) {
        formatted += text.substring(0, 4);
        if (text.length > 4) formatted += '-';
      } else {
        formatted += text;
      }

      if (text.length >= 6) {
        formatted += text.substring(4, 6);
        if (text.length > 6) formatted += '-';
      } else if (text.length > 4) {
        formatted += text.substring(4);
      }

      if (text.length > 6) {
        formatted += text.substring(6);
      }
    } else {
      // dd-MM-yyyy format
      if (text.length >= 2) {
        formatted += text.substring(0, 2);
        if (text.length > 2) formatted += '-';
      } else {
        formatted += text;
      }

      if (text.length >= 4) {
        formatted += text.substring(2, 4);
        if (text.length > 4) formatted += '-';
      } else if (text.length > 2) {
        formatted += text.substring(2);
      }

      if (text.length > 4) {
        formatted += text.substring(4);
      }
    }

    // Update the text controller here (assuming datePicker is your controller)
    if (isYearFirst) {
      datePicker1.value = datePicker.value.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    } else {
      datePicker.value = datePicker.value.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  String? customValidation(String date, {bool isYearFirst = true}) {
    String dateText = date.trim();

    RegExp regExp;
    Match? match;

    if (isYearFirst) {
      // Regex for yyyy-MM-dd
      regExp = RegExp(r"^(\d{4})-(\d{2})-(\d{2})$");
      match = regExp.firstMatch(dateText);

      if (match == null) {
        return "Please enter a valid date in the format yyyy-MM-dd";
      }

      try {
        int year = int.parse(match.group(1)!);
        int month = int.parse(match.group(2)!);
        int day = int.parse(match.group(3)!);

        if (date.isEmpty) {
          return "Enter a valid date format";
        }

        if (day < 1 || day > 31) {
          return "Day should be between 01 and 31.";
        }
        if (month < 1 || month > 12) {
          return "Month should be between 01 and 12.";
        }
        if (year < 1000 || year > 9999) {
          return "Year should be a valid four-digit year.";
        }
      } catch (e) {
        return e.toString();
      }
    } else {
      // Regex for dd-MM-yyyy
      regExp = RegExp(r"^(\d{2})-(\d{2})-(\d{4})$");
      match = regExp.firstMatch(dateText);

      if (match == null) {
        return "Please enter a valid date in the format dd-MM-yyyy";
      }

      try {
        int day = int.parse(match.group(1)!);
        int month = int.parse(match.group(2)!);
        int year = int.parse(match.group(3)!);

        if (date.isEmpty) {
          return "Enter a valid date format";
        }

        if (day < 1 || day > 31) {
          return "Day should be between 01 and 31.";
        }
        if (month < 1 || month > 12) {
          return "Month should be between 01 and 12.";
        }
        if (year < 1000 || year > 9999) {
          return "Year should be a valid four-digit year.";
        }
      } catch (e) {
        return e.toString();
      }
    }

    return null;
  }

  void textfieldManuallyOnPressed({bool isYearFirst = true}) {
    String dateText = datePicker.text.trim();

    RegExp regExp;
    Match? match;

    if (isYearFirst) {
      // Regex for yyyy-MM-dd
      regExp = RegExp(r"^(\d{4})-(\d{2})-(\d{2})$");
      match = regExp.firstMatch(dateText);

      if (match == null) {
        AlertHelper.showFlushBar(
          message: "Please enter the date in yyyy-MM-dd format",
          error: true,
        );
        return;
      }

      try {
        int year = int.parse(match.group(1)!);
        int month = int.parse(match.group(2)!);
        int day = int.parse(match.group(3)!);

        DateTime manualDate = DateTime(year, month, day);
        datePicker1.text = DateFormat(inputFieldLabelText).format(manualDate);
        Get.closeOverlay();
      } catch (e) {
        AlertHelper.showFlushBar(
          message: "Invalid date format! Use $inputFieldLabelText",
          error: true,
        );
      }
    } else {
      // Regex for dd-MM-yyyy
      regExp = RegExp(r"^(\d{2})-(\d{2})-(\d{4})$");
      match = regExp.firstMatch(dateText);

      if (match == null) {
        AlertHelper.showFlushBar(
          message: "Please enter the date in dd-MM-yyyy format",
          error: true,
        );
        return;
      }

      try {
        int day = int.parse(match.group(1)!);
        int month = int.parse(match.group(2)!);
        int year = int.parse(match.group(3)!);

        DateTime manualDate = DateTime(year, month, day);
        datePicker.text = DateFormat(inputFieldLabelText).format(manualDate);
        Get.closeOverlay();
      } catch (e) {
        AlertHelper.showFlushBar(
          message: "Invalid date format! Use $inputFieldLabelText",
          error: true,
        );
      }
    }
  }
}
