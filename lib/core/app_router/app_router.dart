import 'package:flutter/cupertino.dart';

class AppRouter{
  AppRouter();

  Route? onGenerateRoute(RouteSettings settings){
    print('route name: ${settings.name}');
    switch(settings.name){

    }
  }

}