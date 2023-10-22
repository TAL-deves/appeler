import 'package:auth_management/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../index.dart';

class HomeController extends CustomAuthController {
  final MeetingHandler roomHandler;

  HomeController({
    super.backupHandler,
    required this.roomHandler,
  });

  Future<String> generateRoom(String? oldRoomId, {int minutes = 10}) {
    return AnalyticaRTC.roomWork.autoCreateRoomId(
      roomId: oldRoomId,
      minutes: minutes,
    );
  }

  String? generateRoomWithFirebase(String? oldRoomId) {
    if (oldRoomId != null) {
      roomHandler.root.doc(oldRoomId).delete();
    }
    final newDoc = roomHandler.root.doc();
    newDoc.set(<String, dynamic>{});
    var roomId = newDoc.id;
    return roomId;
  }

  Future<bool> verifyId(String? id) async {
    return AnalyticaRTC.repository.read(path: id??"").then((value) {
      if (value.isNotEmpty){
        var data = value["data"];
        return data != null;
      }
      return false;
    });
  }

  Future<bool> verifyIdWithFirebase(String? id) {
    return FirebaseFirestore.instance
        .collection("group-chat-rooms")
        .doc(id)
        .get()
        .then((value) => value.exists);
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
