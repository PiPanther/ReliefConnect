import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Toasts {
  void error(String text) {
    toastification.show(
        title: Text(text),
        autoCloseDuration: const Duration(seconds: 5),
        type: ToastificationType.error);
  }

  void success(String text) {
    toastification.show(
        title: Text(text),
        autoCloseDuration: const Duration(seconds: 5),
        type: ToastificationType.success);
  }
}
