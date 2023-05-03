import 'package:flutter/material.dart';

const kTextFieldColor = Color(0xffF4F4F4);
const kRedColor = Colors.red;
const kGreenColor = Colors.green;
const kLoginTextButtonColor = Color(0xff002054);
const kAppYellowColor = Color(0xffF8B100);
const kLightYellowColor = Color(0xffF6F6BC);
const kWhiteColor = Colors.white;
const kLockerBoxColor = Color(0xffD9D9D9);
const kBlackShadowColor = Colors.black12;
const kAppBarIconBackGround = Color(0xffE0DEDA);
const kBottomNavigationColor = Color(0xffEEEEEE);
const kBlackColor = Colors.black;
const kLightGreyColor = Color(0xffD3D3D3);

const kPrimaryColor = Colors.blue;
final kOrangeColor = Colors.orange[800];

class KColors {
  static const MaterialColor primary = MaterialColor(
    _primary,
    <int, Color>{
      50: Color(0xffF8B100),
      100: Color(0xffF8B100),
      200: Color(0xffF8B100),
      300: Color(0xffF8B100),
      400: Color(0xffF8B100),
      500: Color(_primary),
      600: Color(0xffF8B100),
      700: Color(0xffF8B100),
      800: Color(0xffF8B100),
      900: Color(0xffF8B100),
    },
  );
  static const int _primary = 0xffF8B100;

  static MaterialStateProperty<Color?>? primaryButtonBackground =
      MaterialStateProperty.all(primary);
}
