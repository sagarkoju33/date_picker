import 'package:date_picker/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertHelper {
  AlertHelper._();

  static void showFlushBar({
    required String message,
    double? verticalMargin,
    bool error = false,
    int? duration,
  }) async {
    Get.snackbar(
      "",
      "",
      backgroundColor: error ? AppColors.validatorError : Colors.green,
      duration: Duration(milliseconds: duration ?? 1500),
      icon: Icon(error ? Icons.error : Icons.check_circle, color: Colors.white),
      titleText: Padding(
        padding: const EdgeInsets.only(top: 08),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
            GestureDetector(
              onTap: () {
                Get.closeAllSnackbars();
              },
              child: const Icon(Icons.clear, color: Colors.white),
            ),
          ],
        ),
      ),
      messageText: const SizedBox.shrink(),
      // Use this to hide the default message
      snackStyle: SnackStyle.floating,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 08),
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: verticalMargin ?? 20,
      ),
      snackPosition: SnackPosition.bottom,
    );
  }
}
