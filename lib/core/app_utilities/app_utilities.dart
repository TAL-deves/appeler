import 'package:flutter/cupertino.dart';

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
}