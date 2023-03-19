import 'dart:ui';
import 'package:appeler/core/app_constants/app_color.dart';
import 'package:appeler/modules/auth/api/auth_management.dart';
import 'package:flutter/material.dart';
import 'app_button.dart';

class AppAlertDialog {
  AppAlertDialog._();

  static Future logoutAlertDialog({required BuildContext context}) {
    return showDialog(
      context: context,
      //barrierDismissible: false,
      builder: (innerContext) {
        return const _CommonDialogBody(
          title: 'Logout',
          bodyMessage: 'Are you sure you want to logout?',
        );
      },
    );
  }
}

class _DialogCommonFilter extends StatelessWidget {
  const _DialogCommonFilter({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: child,
    );
  }
}

class _CommonDialogBody extends StatelessWidget {
  const _CommonDialogBody({
    Key? key,
    required this.title,
    required this.bodyMessage,
  }) : super(key: key);

  final String title, bodyMessage;

  @override
  Widget build(BuildContext context) {
    return _DialogCommonFilter(
      child: AlertDialog(
        title: Text(title),
        content: Text(bodyMessage),
        actions: [
          const AppCommonButton(
            title: 'Ok',
            onPressed: AuthManagementUseCase.logout,
            color: kGreenColor,
          ),
          AppCommonButton(
            title: 'Cancel',
            onPressed: () { Navigator.pop(context); },
            color: kRedColor,
          )
        ],
      ),
    );
  }
}
