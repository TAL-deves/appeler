import 'package:appeler/new_modules/new_home/group_chat/group_chat_screen.dart';
import 'package:appeler/new_modules/new_home/new_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../modules_old/auth/api/auth_management.dart';
import '../../modules_old/auth/phone/page.dart';
import '../../modules_old/calling/screen/calling_screen.dart';
import '../../modules_old/group_calling/screen/for_client/group_calling_client_screen.dart';
import '../../modules_old/group_calling/screen/for_host/group_calling_host_screen.dart';
import '../../modules_old/home/screen/home_screen.dart';

const kDefaultRoute = '/';

const appRouter = AppRouter();

class AppRouter{
  const AppRouter();

  Route? onGenerateRoute(RouteSettings settings){
    switch(settings.name){
      case kDefaultRoute:
        if(AuthManagementUseCase.isUserLoggedIn()){
          return MaterialPageRoute(
            //builder: (context) => const AppHomeScreen(),
            builder: (context) => const NewHomeScreen(),
          );
        }
        else{
          return MaterialPageRoute(
            builder: (context) => const AuthPhonePage(),
          );
        }
      case authScreenRoute:
        return MaterialPageRoute(
          builder: (context) => const AuthPhonePage(),
        );
      case homeScreenRoute:
        return MaterialPageRoute(
          //builder: (context) => const AppHomeScreen(),
          builder: (context) => const NewHomeScreen(),
        );
      case callingScreenRoute:
        final curList = settings.arguments as List<dynamic>;
        final curId = curList[0];
        final callEnum = curList[1];
        return MaterialPageRoute(
          builder: (context) => CallingScreen(id: curId, callEnum: callEnum),
        );
      case groupCallingHostScreenRoute:
        final curList = settings.arguments as List<QueryDocumentSnapshot<Map<String, dynamic>>>;
        return MaterialPageRoute(
          builder: (context) => GroupCallingHostScreen(curList: curList),
        );
      case groupCallingClientScreenRoute:
        final callerHostId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (context) => GroupCallingClientScreen(callerHostId: callerHostId),
        );
      case kGroupChatScreenRoute:
        final groupId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => GroupChatScreen(groupId: groupId),
        );
      default:
        return null;
    }
  }

}