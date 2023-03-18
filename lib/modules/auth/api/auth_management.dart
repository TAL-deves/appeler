import 'package:appeler/core/app_utilities/app_utilities.dart';
import 'package:appeler/modules/home/screen/home_screen.dart' show homeScreenRoute;
import 'package:appeler/widgets/app_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AuthManagementUseCase{
  static final _users = FirebaseFirestore.instance.collection('users');

  static Future<bool> login({required String phoneNumber, required String password}) async{
    if(phoneNumber.isEmpty || password.isEmpty){
      AppSnackBar.showFailureSnackBar(message: 'Phone number or password can not be empty!');
      return Future.value(false);
    }
    else{
      try{
        final docUser = await _users.doc(phoneNumber).get();
        if(docUser.exists){
          final curData = docUser.data()!;
          if(curData['password'] != password){
            AppSnackBar.showFailureSnackBar(message: 'Password does not match!');
            return Future.value(false);
          }
          else{
            AppSnackBar.showSuccessSnackBar(message: 'Login Success!');
            Navigator.of(AppUtilities.curNavigationContext!).pushReplacementNamed(homeScreenRoute);
            return Future.value(true);
          }
        }
        else{
          AppSnackBar.showFailureSnackBar(message: 'User not found!');
          return Future.value(false);
        }
      }
      catch(e){
        final errorMessage = e.toString();
        AppSnackBar.showFailureSnackBar(message: errorMessage);
        return Future.value(false);
      }
    }
  }
}