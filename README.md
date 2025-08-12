<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

A date picker is a UI component that allows users to select a date visually, usually from a calendar interface. In Flutter, showDatePicker is a built-in function that opens a modal dialog where users can select a date.The date returned by the picker is a DateTime object.DateTime is a class that represents a specific point in time (year, month, day, hour, minute, second).However, DateTime itself does not contain any human-readable formatting — it’s just raw data.

Why Format Dates?
When you want to display a date to the user, you rarely show the raw DateTime.toString(), because it uses a fixed ISO format like "2025-08-12 00:00:00.000", which is not user-friendly.
Instead, you want to show the date in a format appropriate to your app’s language, locale, and style preferences, for example:

```dart
"12-08-2025" (common numeric date)

"August 12, 2025" (longer textual format)

"Tuesday, Aug 12, 2025" (including weekday)
```

The Role of the intl Package
Flutter itself does not provide flexible date formatting — that’s where the intl package comes in.

1. intl stands for internationalization.
2. It provides classes and methods to format and parse dates and numbers according to locale and pattern.
3. It lets you convert a DateTime into a string in any format you want, respecting cultural norms (e.g., order of day/month/year, names of months in different languages).

How Does intl Work?

1. The core class for date formatting is DateFormat.
2. You create a DateFormat object with a pattern (like "dd-MM-yyyy") or a predefined style (DateFormat.yMd(), DateFormat.yMMMMd(), etc.).
3. You then call .format(dateTime) to get a string.
4. You can also specify a locale (e.g., "en_US" or "fr_FR") to format dates according to regional preferences.
   Example

| Pattern Symbol | Meaning             | Example Output |
| -------------- | ------------------- | -------------- |
| `y`            | Year                | 2025           |
| `M`            | Month number        | 8 (August)     |
| `MM`           | Month, 2 digits     | 08             |
| `MMM`          | Abbreviated month   | Aug            |
| `MMMM`         | Full month name     | August         |
| `d`            | Day of month        | 12             |
| `dd`           | Day with zero       | 12             |
| `E` or `EEE`   | Day of week (short) | Tue            |
| `EEEE`         | Full day of week    | Tuesday        |

## Features

1. User-Friendly Date Selection
   Provides a visual calendar interface.
   Easy to select year, month, and day without manual input.
   Prevents invalid date entries (e.g., no 31st of February).
2. Customization of Date Range
   You can restrict the date picker to allow only dates within a specific range:
   firstDate: The earliest selectable date.
   lastDate: The latest selectable date.
3. Initial Date Control
   You can set the initially focused date when the picker opens, improving UX by focusing on relevant dates.
4. Date Formatting and Localization with intl
   After picking, the raw DateTime can be formatted to any pattern or locale.
   Supports locale-aware formats so the date looks familiar to users from different regions.
   Offers multiple predefined formats and custom patterns.

```dart
DateFormat('dd-MM-yyyy').format(selectedDate);
DateFormat.yMMMMd('fr_FR').format(selectedDate); // French locale
```

5. Support for Different Date Formats
   You can display the selected date in formats like:
   Numeric: 12-08-2025
   Long textual: August 12, 2025
   Full weekday + date: Tuesday, Aug 12, 2025
   Helps match the date display to your app’s design language or user preference.
6. Integration with Form Validation
   Date picker inputs can be validated (e.g., required fields, date ranges).
   Combined with form widgets, the date picker helps create robust user input forms.
7. Accessibility & Usability
   Default Flutter date pickers follow platform conventions:
   Material design on Android.
   Cupertino style on iOS (if using CupertinoDatePicker).
   Makes your app accessible and familiar on different devices.
8. Asynchronous & Modal Operation
   showDatePicker opens asynchronously.
   Code execution waits for user selection or cancellation.
   This fits well with Flutter’s event-driven UI.
9. Customizable UI
   You can customize the date picker theme (colors, fonts).
   For more control, you can build a custom date picker UI if needed.
10. Support for Different Calendar Systems (Advanced)
    While Flutter’s default picker uses the Gregorian calendar, intl supports other locales and calendars.

For specific calendar systems, third-party packages or custom implementations are available.

## Getting started

## Installation

1. Add the latest version of package to your pubspec.yaml (and rundart pub get):

```dart
dependencies:
  date_picker: ^0.0.1
```

2. Import the package and use it in your Flutter App.

```dart
  import 'package:date_picker/date_picker.dart';
```

## Usage

```dart
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
```

## Output

<img src="https://github.com/sagarkoju33/date_picker/blob/main/assets/output.png" alt="Success Status" width="300" height="540">
