import 'package:flutter/material.dart';

import '../index.dart';

class AppSnackBar {
  static void showSuccessSnackBar({required String? message}) {
    _showSnackBar(message: message, backgroundColor: kGreenColor);
  }

  static void showFailureSnackBar({required String? message}) {
    _showSnackBar(message: message, backgroundColor: kRedColor);
  }

  static void _showSnackBar({
    required String? message,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(AppUtilities.curNavigationContext!).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        content: Text(message ?? 'N/A'),
      ),
    );
  }
}
