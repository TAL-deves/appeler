import 'dart:ui';

import 'package:appeler/modules_old/calling/screen/call_enum/call_enum.dart';
import 'package:appeler/modules_old/calling/screen/calling_screen.dart';
import 'package:appeler/modules_old/group_calling/screen/for_client/group_calling_client_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../index.dart';

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
          body: 'Are you sure you want to logout?',
          onPressOk: AuthManagementUseCase.logout,
        );
      },
    );
  }

  static Future incomingCallDialog(
      {required BuildContext context, String? callerId}) {
    inCallDialogIsOpen = true;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (innerContext) {
        return _CommonDialogBody(
          title: 'Calling from $callerId',
          body: 'Press ok for accept and cancel for reject',
          onPressOk: () {
            Navigator.of(context).pushNamed(callingScreenRoute,
                arguments: [callerId, CallEnum.incoming]);
          },
        );
      },
    );
  }

  static Future incomingGroupCallDialog(
      {required BuildContext context, String? callerHostId}) {
    inCallDialogIsOpen = true;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (innerContext) {
        return _CommonDialogBody(
          title: 'Group Calling from $callerHostId',
          body: 'Press ok for accept and cancel for reject',
          onPressOk: () {
            Navigator.of(context).pushNamed(groupCallingClientScreenRoute,
                arguments: callerHostId);
          },
        );
      },
    );
  }

  static Future outGoingCallDialog(
      {required BuildContext context, String? callerId}) {
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

  //NEW V2
  static var logoutDialogIsOpen = false;

  static Future<bool?> exitAlertDialog({required BuildContext context}) {
    return showDialog<bool>(
        context: context,
        builder: (innerContext) {
          return const _ExitDialogBody();
        });
  }

  static Future<bool?> clearTokenAlertDialog(
      {required BuildContext context,
      required int? errorCode,
      required String errorMessage,
      required String title}) {
    return showDialog<bool>(
      context: context,
      builder: (innerContext) {
        return _ClearTokenDialogBody(
          errorMessage: errorMessage,
          errorCode: errorCode,
          title: title,
        );
      },
    );
  }

  static Future textShowAlertDialogFromNavContext(
      {required String? title, required String? bodyMessage}) {
    return showDialog(
      context: AppUtilities.curNavigationContext!,
      barrierDismissible: false,
      builder: (innerContext) {
        return _TextDialogBody(title: title, bodyMessage: bodyMessage);
      },
    );
  }

  static Future languageChangeDialog() {
    return showDialog(
      context: AppUtilities.curNavigationContext!,
      builder: (innerContext) {
        return const _ChangeLanguageDialogBody();
      },
    );
  }

  static Future deleteDialog() {
    return showDialog(
      context: AppUtilities.curNavigationContext!,
      builder: (innerContext) {
        return const _DeleteDialogBody();
      },
    );
  }

  static Future commonAlertDialog(
      {required String title,
      required String body,
      Color? titleColor,
      bool? showOkButton,
      bool? dismissible}) {
    return showDialog(
      context: AppUtilities.curNavigationContext!,
      barrierDismissible: dismissible ?? true,
      builder: (innerContext) {
        return _CommonDialogBody(
          title: title,
          body: body,
          titleColor: titleColor,
          showOkButton: showOkButton ?? false,
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
    this.title = "",
    this.titleColor,
    this.body = "",
    this.showOkButton = false,
    this.onPressOk,
  }) : super(key: key);

  final String title, body;
  final Color? titleColor;
  final bool showOkButton;
  final Function()? onPressOk;

  @override
  Widget build(BuildContext context) {
    return _DialogCommonFilter(
      child: AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          AppCommonButton(
            text: 'Ok',
            onClick: () {
              AppAlertDialog.inCallDialogIsOpen = false;
              Navigator.pop(context, true);
              onPressOk?.call();
            },
            textColor: titleColor ?? kGreenColor,
          ),
          AppCommonButton(
            text: 'Cancel',
            onClick: () {
              AppAlertDialog.inCallDialogIsOpen = false;
              Navigator.pop(context, false);
            },
            textColor: kRedColor,
          )
        ],
      ),
    );
  }
}

class _DeleteDialogBody extends StatelessWidget {
  const _DeleteDialogBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _DialogCommonFilter(
      child: AlertDialog(
        title: Text(LocaleKeys.deleteAccountTitle.tr()),
        content: const _DeleteDialogInnerItem(),
      ),
    );
  }
}

class _DeleteDialogInnerItem extends StatefulWidget {
  const _DeleteDialogInnerItem({Key? key}) : super(key: key);

  @override
  State<_DeleteDialogInnerItem> createState() => _DeleteDialogInnerItemState();
}

class _DeleteDialogInnerItemState extends State<_DeleteDialogInnerItem> {
  var isFirst = true;
  var totalHit = 0;
  late final config = SizeConfig.of(context);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isFirst)
          Text(LocaleKeys.deleteAccountMsg.tr())
        else
          totalHit < 10
              ? Text('Press Okay ${10 - totalHit} times to continue')
              : Text(LocaleKeys.deletingAccount.tr()),
        SizedBox(height: config.px(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (totalHit < 10)
              AlertDialogButton(
                  title: LocaleKeys.cancel.tr(),
                  onTap: () => Navigator.pop(context, false)),
            if (totalHit < 10)
              AlertDialogButton(
                  title: LocaleKeys.ok.tr(),
                  onTap: () {
                    setState(() {
                      isFirst = false;
                      ++totalHit;
                      if (totalHit == 10) {
                        di<DeleteAccountUseCase>().deleteCurUserAccount();
                      }
                    });
                  }),
          ],
        )
      ],
    );
  }
}

class _ChangeLanguageDialogBody extends StatelessWidget {
  const _ChangeLanguageDialogBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _DialogCommonFilter(
      child: AlertDialog(
        title: Text(LocaleKeys.pleaseSelectLanguage.tr(),
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        content: _OuterLanguageSelection(
          selectedLanguage: context.locale.languageCode == 'en' ? 0 : 1,
          onChangeLanguage: (value) async {
            if (value == 0) {
              await context.setLocale(const Locale('en'));
            } else {
              await context.setLocale(const Locale('bn'));
            }
            engine.performReassemble();
          },
        ),
        actions: [
          AppDeepBlueButton(
            title: LocaleKeys.ok.tr(),
            onPressed: () => Navigator.pop(context),
            width: 100,
            customRadius: 10,
          )
        ],
      ),
    );
  }
}

class _OuterLanguageSelection extends StatelessWidget {
  const _OuterLanguageSelection({
    Key? key,
    required this.selectedLanguage,
    required this.onChangeLanguage,
  }) : super(key: key);

  final int selectedLanguage;
  final Function(int) onChangeLanguage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _InnerLanguageSelection(
            selectedLanguage: selectedLanguage,
            onChangeLanguage: onChangeLanguage),
      ],
    );
  }
}

class _InnerLanguageSelection extends StatefulWidget {
  const _InnerLanguageSelection({
    Key? key,
    required this.selectedLanguage,
    required this.onChangeLanguage,
  }) : super(key: key);

  final int selectedLanguage;
  final Function(int) onChangeLanguage;

  @override
  State<_InnerLanguageSelection> createState() =>
      _InnerLanguageSelectionState();
}

class _InnerLanguageSelectionState extends State<_InnerLanguageSelection> {
  late var _selectedId = widget.selectedLanguage;

  @override
  void didUpdateWidget(covariant _InnerLanguageSelection oldWidget) {
    _selectedId = widget.selectedLanguage;
    super.didUpdateWidget(oldWidget);
  }

  void _setId(int curId) {
    if (curId != _selectedId) {
      setState(() {
        _selectedId = curId;
        widget.onChangeLanguage.call(_selectedId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LanguageTextWidget(
          title: 'English',
          isSelected: _selectedId == 0,
          onPressed: () {
            _setId(0);
          },
          flagImagePath: 'assets/images/uk_flag.png',
        ),
        const SizedBox(height: 5),
        _LanguageTextWidget(
          title: 'বাংলা',
          isSelected: _selectedId == 1,
          onPressed: () {
            _setId(1);
          },
          flagImagePath: 'assets/images/bd_flag.png',
        )
      ],
    );
  }
}

class _LanguageTextWidget extends StatelessWidget {
  const _LanguageTextWidget({
    Key? key,
    required this.isSelected,
    required this.title,
    required this.onPressed,
    required this.flagImagePath,
  }) : super(key: key);

  final bool isSelected;
  final String title, flagImagePath;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AbsorbPointer(
        child: AnimatedContainer(
          padding: const EdgeInsets.all(4),
          width: 180,
          decoration: BoxDecoration(
            color: isSelected ? kLoginTextButtonColor : kWhiteColor,
            borderRadius: BorderRadius.circular(5),
          ),
          duration: const Duration(milliseconds: 500),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style:
                      TextStyle(color: isSelected ? kWhiteColor : kBlackColor)),
              Image.asset(flagImagePath, height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextDialogBody extends StatelessWidget {
  const _TextDialogBody({
    Key? key,
    required this.title,
    required this.bodyMessage,
  }) : super(key: key);

  final String? title, bodyMessage;

  @override
  Widget build(BuildContext context) {
    return _DialogCommonFilter(
      child: AlertDialog(
        title: Text(title ?? LocaleKeys.na.tr()),
        content: Text(bodyMessage ?? LocaleKeys.na.tr()),
      ),
    );
  }
}

class _ClearTokenDialogBody extends StatelessWidget {
  const _ClearTokenDialogBody({
    Key? key,
    required this.errorMessage,
    required this.errorCode,
    required this.title,
  }) : super(key: key);

  final int? errorCode;
  final String errorMessage;
  final String title;

  @override
  Widget build(BuildContext context) {
    return _DialogCommonFilter(
      child: AlertDialog(
        //title: Text('${LocaleKeys.errorCode.tr()}: $errorCode'),
        title: Text(title.tr(),
            style:
                const TextStyle(color: kRedColor, fontWeight: FontWeight.bold)),
        //content: Text(errorMessage ?? LocaleKeys.na.tr(), textAlign: TextAlign.justify),
        content: Text(errorMessage.tr(), textAlign: TextAlign.justify),
        actions: [
          AlertDialogButton(
              title: LocaleKeys.cancel.tr(),
              onTap: () => Navigator.pop(context, false)),
          AlertDialogButton(
              title: LocaleKeys.clear.tr(),
              onTap: () => Navigator.pop(context, true)),
        ],
      ),
    );
  }
}

class _ExitDialogBody extends StatelessWidget {
  const _ExitDialogBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _DialogCommonFilter(
      child: AlertDialog(
        title: Text(LocaleKeys.exit.tr()),
        content: Text(LocaleKeys.areYouSureYouWantToExitFromApp.tr()),
        actions: [
          AlertDialogButton(
              title: LocaleKeys.cancel.tr(),
              onTap: () => Navigator.pop(context, false)),
          AlertDialogButton(
              title: LocaleKeys.ok.tr(),
              onTap: () => Navigator.pop(context, true))
        ],
      ),
    );
  }
}

class _LogoutDialogBody extends StatefulWidget {
  const _LogoutDialogBody({
    Key? key,
  }) : super(key: key);

  @override
  State<_LogoutDialogBody> createState() => _LogoutDialogBodyState();
}

class _LogoutDialogBodyState extends State<_LogoutDialogBody> {
  var _logoutPressed = false;
  var _hasError = false;

  Widget get _dialogCancelButton => AlertDialogButton(
        title: LocaleKeys.cancel.tr(),
        onTap: () {
          AppAlertDialog.logoutDialogIsOpen = false;
          Navigator.pop(context);
        },
      );

  String get _showStringAccordingToState {
    if (_hasError) {
      return LocaleKeys.errorOccurredPleaseTryAgain.tr();
    } else {
      if (_logoutPressed) {
        return LocaleKeys.loggingOutPleaseWait.tr();
      } else {
        return LocaleKeys.areYouSureWantToLogoutFromApp.tr();
      }
    }
  }

  void _logoutWork() async {
    setState(() {
      _hasError = false;
      _logoutPressed = true;
    });
    final response = await AppUtilities.logoutFromApplication();
    if (response == null) {
      setState(() {
        _hasError = true;
        _logoutPressed = false;
      });
    } else {
      AppAlertDialog.logoutDialogIsOpen = false;
    }
  }

  List<Widget> get _showActionAccordingToState {
    if (_hasError) {
      return [
        _dialogCancelButton,
        AlertDialogButton(
          title: LocaleKeys.retry.tr(),
          onTap: _logoutWork,
        ),
      ];
    } else {
      if (_logoutPressed) {
        return [];
      } else {
        return [
          _dialogCancelButton,
          AlertDialogButton(
            title: LocaleKeys.ok.tr(),
            onTap: _logoutWork,
          ),
        ];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _DialogCommonFilter(
      child: AlertDialog(
        title: Text(LocaleKeys.logout.tr()),
        content: Text(_showStringAccordingToState),
        actions: _showActionAccordingToState,
      ),
    );
  }
}
