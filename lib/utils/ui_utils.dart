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
