//*these date picker are made custom to show the label based on the dd-mm-yyyy on the custom textField on the edit icon of the calendar*/
import 'package:custom_date_picker/colors/colors.dart';
import 'package:custom_date_picker/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// Import the intl package

class CustomDatePickerScreen extends StatefulWidget {
  const CustomDatePickerScreen({
    super.key,
    required this.dateController,
    required this.hintText,
    this.showAllDate = false,
    this.showBeforeDate = false,
    this.showFutureDate = false,
    this.isAgeBelowValidation = false,
    this.showEmailCaseRequiredSignUp = false,
    this.validateName,
    this.focusNode,
    this.onChanged,
    this.suffixWidget,
    this.inputFieldCustomValidation,
    this.hideEditIcon = true,
    this.inputFieldOnChanged,
    this.inputFieldHintText,
    this.inputFieldLabelText,
    this.onOkButtonClicked,
    this.labelText = "Select Date",
  });

  final TextEditingController dateController;
  final String hintText;
  final bool showFutureDate;
  final bool showBeforeDate;
  final bool showAllDate;
  final bool isAgeBelowValidation;
  final String? validateName;
  final FocusNode? focusNode;
  final bool showEmailCaseRequiredSignUp;
  final Function(String text)? onChanged;
  final Widget? suffixWidget;
  final Function(String text)? inputFieldOnChanged;
  final Function(String text)? inputFieldCustomValidation;
  final bool hideEditIcon;
  final String? inputFieldLabelText;
  final String? inputFieldHintText;
  final Function? onOkButtonClicked;
  final String? labelText;

  @override
  CustomDatePickerScreenState createState() => CustomDatePickerScreenState();
}

class CustomDatePickerScreenState extends State<CustomDatePickerScreen> {
  DateTime selectedDate = DateTime.now();

  void _updateSelectedDate(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
      widget.dateController.text = DateFormat(
        widget.inputFieldLabelText ?? "yyyy-MM-dd",
      ).format(selectedDate);
    });
    Get.closeOverlay();
  }

  void _showCustomDatePicker(BuildContext context) async {
    DateTime minDate = widget.showBeforeDate
        ? DateTime(1930)
        : widget.showAllDate
        ? DateTime(2015, 8)
        : DateTime.now();
    DateTime maxDate = widget.showFutureDate
        ? DateTime(2090, 2, 5)
        : widget.showAllDate
        ? DateTime(2101)
        : DateTime.now();

    DateTime safeDate = selectedDate;
    if (safeDate.isBefore(minDate)) safeDate = minDate;
    if (safeDate.isAfter(maxDate)) safeDate = maxDate;

    DateTime? pickedDate = await showDialog(
      context: context,
      builder: (context) => PopScope(
        canPop: false,
        child: CustomDatePickerDialog(
          initialDate: safeDate, // ✅ always valid now
          firstDate: minDate,
          lastDate: maxDate,
          onDatePicked: _updateSelectedDate,
          controller: widget.dateController,
          showFutureDate: widget.showFutureDate,
          onDateSelection: widget.onChanged,
          inputLabelText: widget.inputFieldLabelText ?? "yyyy-MM-dd",
          inputHintText: widget.inputFieldHintText ?? "yyyy-MM-dd",
          inputFieldOnChanged: (text) {
            widget.inputFieldOnChanged?.call(text);
          },
          inputFieldCustomValidation: (text) {
            widget.inputFieldCustomValidation?.call(text);
          },
          hideEditIcon: widget.hideEditIcon,
          onOkButtonClicked: widget.onOkButtonClicked,
        ),
      ),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      textController: widget.dateController,
      hintText: widget.hintText,
      labelText: widget.labelText,
      suffixWidget: widget.suffixWidget,
      suffixOnTap: () {
        _showCustomDatePicker(context);
      },
      readMode: true,
      hasOnchange: true,
      focusNode: widget.focusNode,

      onTap: () {
        _showCustomDatePicker(context);
      },
      onChanged: (String val) {
        widget.onChanged!(val);
      },
    );
  }
}

class CustomDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime) onDatePicked;
  final TextEditingController controller;
  final bool showFutureDate;
  final Function(String data)? onDateSelection;
  final String inputLabelText;
  final String inputHintText;
  final Function(String text)? inputFieldOnChanged;
  final Function(String text)? inputFieldCustomValidation;
  final bool hideEditIcon;
  final Function? onOkButtonClicked;

  const CustomDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDatePicked,
    required this.controller,
    this.showFutureDate = false,
    this.onDateSelection,
    this.inputLabelText = "yyyy-MM-dd",
    this.inputHintText = "yyyy-MM-dd",
    this.inputFieldOnChanged,
    this.inputFieldCustomValidation,
    this.hideEditIcon = true,
    this.onOkButtonClicked,
  });

  @override
  CustomDatePickerDialogState createState() => CustomDatePickerDialogState();
}

class CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.text = "";
    });
    selectedDate = widget.initialDate;
  }

  bool showToggleEditIcon = false;

  void _onEditIconPress() {
    setState(() {
      showToggleEditIcon = !showToggleEditIcon;
    });
  }

  GlobalKey<FormState> dateKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Text(
              "Select date",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEEE, MMM d').format(selectedDate),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  widget.hideEditIcon
                      ? IconButton(
                          onPressed: _onEditIconPress,
                          icon: showToggleEditIcon
                              ? const Icon(Icons.calendar_today)
                              : const Icon(Icons.edit),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            const Divider(color: Colors.black),
            const SizedBox(height: 8),
            showToggleEditIcon
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: dateKey,
                      child: CustomTextField(
                        textController: widget.controller,
                        hintText: widget.inputHintText,
                        labelText: widget.inputLabelText,
                        enabledBorderColor: Colors.black54,
                        keyboardType: TextInputType.number,
                        onTap: () {},
                        hasOnchange: true,
                        onChanged: (p0) {
                          widget.inputFieldOnChanged?.call(p0);
                        },
                        customValidator: (value) {
                          return widget.inputFieldCustomValidation?.call(value);
                        },
                      ),
                    ),
                  )
                : CalendarDatePicker(
                    initialDate: selectedDate,
                    firstDate: widget.firstDate,
                    lastDate: widget.lastDate,
                    onDateChanged: (date) {
                      widget.onDateSelection?.call(
                        DateFormat(widget.inputHintText).format(date),
                      );
                      widget.onDatePicked(date);
                      Get.back(result: date);

                      setState(() {
                        selectedDate = date;
                        widget.controller.text = DateFormat(
                          widget.inputHintText,
                        ).format(date);
                      });
                    },
                  ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    widget.controller.clear();
                    Get.closeOverlay();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    if (showToggleEditIcon) {
                      if (dateKey.currentState!.validate()) {
                        widget.onOkButtonClicked?.call();
                        setState(() {});
                      }
                    } else {
                      widget.onDatePicked(selectedDate);
                    }
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
