import 'package:appeler/core/app_utilities/app_utilities.dart';
import 'package:flutter/material.dart';
import '../core/app_constants/app_color.dart';

class AppSnackBar{
  static void showSuccessSnackBar({required String? message}){
    _showSnackBar(message: message, backgroundColor: kGreenColor);
  }

  static void showFailureSnackBar({required String? message}){
    _showSnackBar(message: message, backgroundColor: kRedColor);
  }

  static void _showSnackBar({required String? message, required Color backgroundColor}){
    ScaffoldMessenger.of(AppUtilities.curNavigationContext!).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        content: Text(message ?? 'N/A'),
      ),
    );
  }
}