import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_andomie/core.dart';

import '../../../index.dart';

class HomeController extends DefaultAuthController {
  final MeetingHandler roomHandler;

  HomeController({
    required super.handler,
    required super.userHandler,
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
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
        await userHandler.delete(createUid?.call(user.uid) ?? user.uid);
        await signOut();
        emit(AuthResponse.unauthenticated(
          "Account has been deleted successfully!",
        ));
      } else {
        emit(AuthResponse.failure("User not valid!"));
      }
    } catch (_) {
      //emit(AuthResponse.failure(_.toString()));
    }
  }
}
