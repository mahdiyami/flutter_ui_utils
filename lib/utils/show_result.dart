import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentation/presentation.dart';
import 'package:weton_core_base/extension/ext.dart';

enum SnackbarType { error, success, message, warning }

void showTheResult(
    {required SnackbarType snackbarType,
    required String message,
    String? title,
    Function? action,
    String? actionText,
    IconData? icon}) {
  snackBar(snackbarType, message, action: action, actionText: actionText, icon: icon, title: title);
}

void snackBar(SnackbarType resultType, String message,
    {String? title, Function? action, String? actionText, IconData? icon}) {
  var theme = Get.theme;
  Get.rawSnackbar(
      icon: icon != null
          ? Icon(
              icon,
              color: Colors.white,
            )
          : null,
      messageText: Text(
        message,
        style: theme.textTheme.bodyLarge!.onError,
      ),
      snackStyle: SnackStyle.FLOATING,
      borderRadius: C.corners.xxs,
      duration: const Duration(milliseconds: 4500),
      backgroundColor: resultType == SnackbarType.success
          ? Colors.green
          : resultType == SnackbarType.error
              ? Get.theme.colorScheme.error
              : resultType == SnackbarType.warning
                  ? Get.theme.colorScheme.secondary
                  : Colors.grey.shade800,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(C.insets.md));
}
