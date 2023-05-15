import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../index.dart';

class AppUtilities{

  AppUtilities._();

  static final appNavigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get curNavigationContext => appNavigatorKey.currentContext;

  static void popTopWidget(){
    final curContext = curNavigationContext;
    if(curContext != null){ Navigator.pop(curContext); }
  }

  static void pushNamed(String routeName){
    final curContext = curNavigationContext;
    if(curContext != null){ Navigator.of(curContext).pushNamed(routeName); }
  }

  static Future _popAllAndGotoLoginPage({Map<String, String>? deleteMap}){
    return Navigator.of(curNavigationContext!).pushNamedAndRemoveUntil(SignInPage.route, (route) => false, arguments: deleteMap);
  }

  static Future<void> _clearFirebaseToken() async{
    return FirebaseMessaging.instance.deleteToken();
  }

  static Future<CommonReceiveResponse?> logoutFromApplication() async{
    if(curNavigationContext != null){
      final apiResponse = await di<AuthManager>().signOut();
      if(apiResponse != null){
        AppSnackBar.showSuccessSnackBar(message: apiResponse.data!);
        await _clearFirebaseToken();
        await _popAllAndGotoLoginPage();
        return apiResponse;
      }
      else { return null; }
    }
    else { return null; }
  }

  static Future<void> forceLogoutFromApplication({Map<String, String>? deleteMap}) async{
    if(curNavigationContext != null){
      final resultOk = await di<AuthManager>().forceSignOut();
      if(resultOk){
        await _clearFirebaseToken();
        await _popAllAndGotoLoginPage(deleteMap: deleteMap);
      }
    }
  }
}