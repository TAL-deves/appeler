import 'package:auth_management/core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../index.dart';

class HomeController extends CustomAuthController {
  final MeetingHandler roomHandler;

  HomeController({
    super.backupHandler,
    required this.roomHandler,
  });

  String? generateRoom(String? oldRoomId) {
    if (oldRoomId != null) {
      roomHandler.root.doc(oldRoomId).delete();
    }
    final newDoc = roomHandler.root.doc();
    newDoc.set(<String, dynamic>{});
    var roomId = newDoc.id;
    return roomId;
  }

  Future deleteAccount() async {
    emit(AuthResponse.loading());
    try {
      if (user != null) {
        await user?.delete();
        await super.backupHandler.onDeleted(user?.uid ?? "");
        await signOut();
        Fluttertoast.showToast(
          msg: "User account successfully deleted!",
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
        );
        emit(AuthResponse.unauthenticated());
      } else {
        emit(AuthResponse.failure("User not valid!"));
      }
    } catch (_) {
      //emit(AuthResponse.failure(_.toString()));
    }
  }
}
