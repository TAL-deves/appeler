import 'dart:async';

import 'package:auth_management/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_management/core.dart';

import '../../../index.dart';

class MeetingHandler extends RemoteDataHandlerImpl<Meeting> {
  MeetingHandler(RemoteDataSource<Meeting> source)
      : super.fromSource(source: source);

  CollectionReference get root {
    return FirebaseFirestore.instance.collection(ApiKeys.meetings);
  }

  DocumentReference getMeetingReference(String id) {
    return root.doc(id);
  }

  Stream<MeetingContributor> liveContributor(String meetingId, String id) {
    final controller = StreamController<MeetingContributor>();
    try {
      root.doc(meetingId).snapshots().listen((event) {
        if (event.exists || event.data() != null) {
          var value = event.data();
          if (value is Map<String, dynamic>) {
            var data = value[id];
            if (data is Map<String, dynamic>) {
              var con = MeetingContributor.from(data);
              controller.add(con);
            }
          }
        } else {
          controller.addError("Data not found!");
        }
      });
    } catch (_) {
      controller.addError(_);
    }
    return controller.stream;
  }

  void setStatus({
    required String meetingId,
    required bool isMute,
    required bool isRiseHand,
    required bool isCameraOn,
    required bool isFrontCamera,
    String? uid,
    String? email,
    String? name,
    String? photo,
    String? phone,
  }) {
    var ref = root.doc(meetingId);
    ref.get().then((value) {
      final data = value.data();
      if (data != null && data is Map<String, dynamic>) {
        data[AuthHelper.uid] = {
          'isMute': isMute,
          'handUp': isRiseHand,
          'isCameraOn': isCameraOn,
          'isFrontCamera': isFrontCamera,
          'meetingId': meetingId,
          'uid': uid,
          'email': email,
          'name': name,
          'photo': photo,
          'phone': phone,
        };
        ref.set(data);
      }
    });
  }

  void changeStatus({
    required String meetingId,
    required bool isMute,
    required bool isRiseHand,
    required bool isCameraOn,
    required bool isFrontCamera,
    String? uid,
    String? email,
    String? name,
    String? photo,
    String? phone,
  }) {
    var ref = root.doc(meetingId);
    ref.get().then((value) {
      final data = value.data();
      if (data != null && data is Map<String, dynamic>) {
        data[AuthHelper.uid] = {
          'isMute': isMute,
          'handUp': isRiseHand,
          'isCameraOn': isCameraOn,
          'isFrontCamera': isFrontCamera,
          'meetingId': meetingId,
          'uid': uid,
          'email': email,
          'name': name,
          'photo': photo,
          'phone': phone,
        };
        ref.update(data);
      }
    });
  }

  void removeStatus(String id) {
    var ref = root.doc(id);
    ref.get().then((value) {
      final data = value.data();
      if (data != null && data is Map<String, dynamic>) {
        data.remove(AuthHelper.uid);
        if (data.isEmpty) {
          ref.delete();
        } else {
          ref.set(data);
        }
      }
    });
  }
}
