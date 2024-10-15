import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastHelper {
  static void showSuccessToast({
    required BuildContext context,
    required String message,
  }) {
    toastification.show(
      context: context,
      title: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      type: ToastificationType.success,
      style: ToastificationStyle.minimal,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  static void showErrorToast({
    required BuildContext context,
    required String message,
  }) {
    toastification.show(
      context: context,
      title: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      type: ToastificationType.error,
      style: ToastificationStyle.minimal,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }
}
