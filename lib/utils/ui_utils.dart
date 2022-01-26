import 'package:get/get.dart';

SnackbarController openSnackbar(
  String title,
  String message, {
  SnackbarController? currentSnackbar,
}) {
  if (currentSnackbar != null) {
    currentSnackbar.close(withAnimations: true);
  }

  return Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    isDismissible: true,
    animationDuration: const Duration(milliseconds: 100),
    instantInit: true,
  );
}
