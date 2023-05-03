import 'package:appeler/core/app_utilities/app_utilities.dart';
import 'package:appeler/modules_old/home/screen/home_screen.dart' show homeScreenRoute;
import 'package:appeler/main.dart' show sharedPref;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../../widgets/app_snack_bar.dart';
import '../phone/page.dart';

class AuthManagementUseCase{
  AuthManagementUseCase._();

  static final _users = FirebaseFirestore.instance.collection('users');
  static const _userKey = 'user';

  static String? get curUser => sharedPref.getString(_userKey);

  static Future<bool> _setUser(String value){
    return sharedPref.setString(_userKey, value);
  }

  static Future<bool> _removeUser(){
    return sharedPref.remove(_userKey);
  }

  static Future<void> logout() async{
    updateOnlineStatus(false);
    if(await _removeUser()){
      Navigator.of(AppUtilities.curNavigationContext!)
          .pushNamedAndRemoveUntil(authScreenRoute, (route) => false);
    }
  }

  static bool isUserLoggedIn(){
    return curUser != null;
  }

  static Future<void> updateOnlineStatus(bool status) async{
    if(curUser != null){
      final docUser = FirebaseFirestore.instance.collection('users').doc(curUser);
      final json = {
        'isOnline': status,
      };
      return await docUser.update(json);
    }
  }

  static Future<void> login({required String phoneNumber, required String password}) async{
    if(phoneNumber.isEmpty || password.isEmpty){
      AppSnackBar.showFailureSnackBar(message: 'Phone number or password can not be empty!');
    }
    else{
      try{
        final docUser = await _users.doc(phoneNumber).get();
        if(docUser.exists){
          final curData = docUser.data()!;
          if(curData['password'] != password){
            AppSnackBar.showFailureSnackBar(message: 'Password does not match!');
          }
          else{
            AppSnackBar.showSuccessSnackBar(message: 'Login Success!');
            _setUser(phoneNumber);
            Navigator.of(AppUtilities.curNavigationContext!).pushReplacementNamed(homeScreenRoute);
          }
        }
        else{ AppSnackBar.showFailureSnackBar(message: 'User not found!'); }
      }
      catch(e){
        final errorMessage = e.toString();
        AppSnackBar.showFailureSnackBar(message: errorMessage);
      }
    }
  }
}