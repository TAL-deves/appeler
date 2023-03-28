import 'dart:ui';
import 'package:appeler/core/app_constants/app_color.dart';
import 'package:appeler/modules/auth/api/auth_management.dart';
import 'package:appeler/modules/calling/screen/call_enum/call_enum.dart';
import 'package:appeler/modules/calling/screen/calling_screen.dart';
import 'package:appeler/modules/group_calling/screen/for_client/group_calling_client_screen.dart';
import 'package:flutter/material.dart';
import 'app_button.dart';

class AppAlertDialog {
  AppAlertDialog._();

  static var inCallDialogIsOpen = false;
  static var outgoingDialogIsOpen = false;

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

  static Future incomingCallDialog({required BuildContext context, String? callerId}) {
    inCallDialogIsOpen = true;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (innerContext) {
        return _CommonDialogBody(
          title: 'Calling from $callerId',
          bodyMessage: 'Press ok for accept and cancel for reject',
          onPressOk: () {
            Navigator.of(context).pushNamed(callingScreenRoute, arguments: [callerId, CallEnum.incoming]);
          },
        );
      },
    );
  }

  static Future incomingGroupCallDialog({required BuildContext context, String? callerHostId}) {
    inCallDialogIsOpen = true;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (innerContext) {
        return _CommonDialogBody(
          title: 'Group Calling from $callerHostId',
          bodyMessage: 'Press ok for accept and cancel for reject',
          onPressOk: () {
            Navigator.of(context).pushNamed(groupCallingClientScreenRoute, arguments: callerHostId);
          },
        );
      },
    );
  }

  static Future outGoingCallDialog({required BuildContext context, String? callerId}) {
    outgoingDialogIsOpen = true;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (innerContext) {
        return _OutgoingDialogBody(
          title: 'Calling to $callerId',
          bodyMessage: 'Press ok for accept and cancel for reject',
          //onPressOk: (){ Navigator.of(context).pushNamed(callingScreenRoute, arguments: callerId); },
        );
      },
    );
  }
}

class _OutgoingDialogBody extends StatelessWidget {
  const _OutgoingDialogBody({
    Key? key,
    required this.title,
    required this.bodyMessage,
  }) : super(key: key);

  final String title;
  final String bodyMessage;

  @override
  Widget build(BuildContext context) {
    return _DialogCommonFilter(
      child: AlertDialog(
        title: Text(title),
        content: Text(bodyMessage),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FloatingActionButton(
            backgroundColor: kRedColor,
            child: const Icon(Icons.phone_disabled),
            onPressed: () {
              AppAlertDialog.outgoingDialogIsOpen = false;
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
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
            onPressed: () {
              AppAlertDialog.inCallDialogIsOpen = false;
              Navigator.pop(context, true);
              onPressOk.call();
            },
            color: kGreenColor,
          ),
          AppCommonButton(
            title: 'Cancel',
            onPressed: () {
              AppAlertDialog.inCallDialogIsOpen = false;
              Navigator.pop(context, false);
            },
            color: kRedColor,
          )
        ],
      ),
    );
  }
}
