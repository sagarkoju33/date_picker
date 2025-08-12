// ignore_for_file: must_be_immutable

import 'package:custom_date_picker/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    required this.textController,
    this.hintText = "",
    this.validatorName = "",
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.sentences,
    this.keyboardType = TextInputType.text,
    this.isPasswordField = false,
    this.readMode = false,
    this.hasOnchange = false,
    this.onTap,
    this.onChanged,
    this.autoValidate = true,
    this.maxLength,
    this.maxLines,
    this.inputFormatters,
    this.labelText,
    this.suffixIcon,
    this.focusNode,
    this.minLines,
    this.enabledBorderColor,
    this.customValidator,
    this.suffixWidget,
    this.suffixOnTap,
  });

  final TextInputType keyboardType;
  final TextEditingController textController;
  final String hintText;
  final String validatorName;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  bool isPasswordField;
  final bool readMode;
  final bool hasOnchange;
  final bool autoValidate;
  final Function()? onTap;
  final Function(String)? onChanged;
  final int? maxLength;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final String? labelText;
  final String? suffixIcon;
  final FocusNode? focusNode;
  final Widget? suffixWidget;
  final int? minLines;
  final Function? suffixOnTap;
  final Color? enabledBorderColor;

  final FormFieldValidator? customValidator;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = true;
  late FocusNode _focusNode;
  bool isFocused = false;
  bool isEmailValid = false;

  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode ?? FocusNode();

    _focusNode.addListener(_onFocusChange);
    widget.textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.textController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      isFocused = _focusNode.hasFocus;
    });
  }

  void _onTextChanged() {
    final text = widget.textController.text;
    if (widget.validatorName.contains("email")) {
      isEmailValid = RegExp(
        r'^.+@[a-zA-Z0-9]+\.[a-zA-Z]+(\.{0,1}[a-zA-Z]+)*$',
      ).hasMatch(text);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        if (widget.readMode) {
          widget.onTap?.call();
        }
      },
      onChanged: (s) {
        if (widget.autoValidate) {
          setState(() {});
        }

        if (widget.hasOnchange) {
          widget.onChanged?.call(s);
        }
      },
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      focusNode: _focusNode,
      readOnly: widget.readMode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.textController,
      obscureText: widget.isPasswordField ? isObscure : false,
      cursorColor: AppColors.primaryColor,
      // style: TextStyle(color: Colors.red),
      decoration: InputDecoration(
        // alignLabelWithHint: true,
        isDense: true,
        fillColor: Colors.transparent,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        hintText: widget.hintText,

        focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
        //  labelText: ,
        filled: true,
        counterText: "",
        label: widget.labelText != null ? Text(widget.labelText!) : null,
        errorStyle: Theme.of(
          context,
        ).inputDecorationTheme.errorStyle?.copyWith(height: 2),
        errorBorder: Theme.of(context).inputDecorationTheme.errorBorder
            ?.copyWith(
              borderSide: const BorderSide(
                width: 1,
                color: AppColors.validatorError,
              ),
            ),
        hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
        enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
        suffixIcon: GestureDetector(
          onTap: () {
            widget.suffixOnTap == null ? null : widget.suffixOnTap!();
          },
          child: widget.suffixWidget,
        ),
        suffixIconConstraints: BoxConstraints.tight(const Size(40.0, 32.0)),
        prefixIconConstraints: BoxConstraints.tight(const Size(80.0, 32.0)),
        border: Theme.of(context).inputDecorationTheme.border,
        labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
      ),
      validator:
          widget.customValidator ??
          (value) {
            return null;
          },
    );
  }
}
