import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController openSnackbar(
  String title,
  String message, {
  SnackbarController? currentSnackbar,
}) {
  if (currentSnackbar != null) {
    if (Get.isSnackbarOpen) {
      currentSnackbar.close(withAnimations: true);
    }
  }

  currentSnackbar = Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    isDismissible: true,
    animationDuration: const Duration(milliseconds: 100),
    instantInit: true,
  );

  return currentSnackbar;
}

SnackbarController showCommandSnackbar(
  bool commandResult,
  String title,
  String successMessage,
  String failureMessage,
) {
  if (commandResult) {
    return openSnackbar(title, successMessage);
  } else {
    return openSnackbar(title, failureMessage);
  }
}

Future openPopup(
  String title,
  String message,
) {
  return showDialog(
    context: Get.context!,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(message),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Got it.'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}
