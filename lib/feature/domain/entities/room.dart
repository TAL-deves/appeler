import 'package:flutter_andomie/core.dart';

import '../../../index.dart';

class Meeting extends Entity {
  final List<MeetingContributor> contributors;

  Meeting({
    super.id = "",
    super.timeMills,
    this.contributors = const [],
  });

  factory Meeting.from(dynamic source) {
    var data = source is Map<String, dynamic> ? source : {};
    final id = data["id"];
    return Meeting(
      id: id ?? "",
    );
  }

  @override
  Map<String, dynamic> get source {
    return {
      "id": id,
      "time_mills": timeMills,
      "contributors": contributors,
    };
  }
}

class MeetingContributor extends Contributor {

  MeetingContributor({
    super.id = "",
    super.timeMills,
    super.cameraOn,
    super.muted,
    super.riseHand,
  });

  factory MeetingContributor.from(dynamic source) {
    var data = source is Map<String, dynamic> ? source : {};
    final id = data["id"];
    final timeMills = data["time_mills"];
    final cameraOn = data["isCameraOn"];
    final mute = data["isMute"];
    final riseHand = data["handUp"];
    return MeetingContributor(
      id: id is String ? id : "",
      timeMills: timeMills is int ? timeMills : 0,
      cameraOn: cameraOn is bool ? cameraOn : false,
      muted: mute is bool ? mute : false,
      riseHand: riseHand is bool ? riseHand : false,
    );
  }

  @override
  Map<String, dynamic> get source {
    return {
      "id": id,
      "time_mills": timeMills,
      "isCameraOn": cameraOn,
      "isMute": muted,
      "handUp": riseHand,
    };
  }
}
