import 'dart:ui';
import 'package:appeler/core/app_constants/app_color.dart';
import 'package:appeler/modules/auth/api/auth_management.dart';
import 'package:appeler/modules/calling/screen/calling_screen.dart';
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
          onPressOk: AuthManagementUseCase.logout,
        );
      },
    );
  }

  static Future callingDialog({required BuildContext context, String? callerId}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (innerContext) {
        return _CommonDialogBody(
          title: 'Calling from $callerId',
          bodyMessage: 'Press ok for accept and cancel for reject',
          onPressOk: (){ Navigator.of(context).pushNamed(callingScreenRoute, arguments: callerId); },
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
    required this.onPressOk,
  }) : super(key: key);

  final String title, bodyMessage;
  final Function() onPressOk;

  @override
  Widget build(BuildContext context) {
    return _DialogCommonFilter(
      child: AlertDialog(
        title: Text(title),
        content: Text(bodyMessage),
        actions: [
          AppCommonButton(
            title: 'Ok',
            onPressed: (){
              Navigator.pop(context, true);
              onPressOk.call();
            },
            color: kGreenColor,
          ),
          AppCommonButton(
            title: 'Cancel',
            onPressed: () { Navigator.pop(context, false); },
            color: kRedColor,
          )
        ],
      ),
    );
  }
}
