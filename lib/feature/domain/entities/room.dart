import 'package:data_management/core.dart';

import '../../../index.dart';

class Meeting extends Data {
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
    super.email,
    super.name,
    super.phone,
    super.photo,
  });

  factory MeetingContributor.from(dynamic source) {
    var data = source is Map<String, dynamic> ? source : {};
    final id = data["id"];
    final email = data["email"];
    final name = data["name"];
    final photo = data["photo"];
    final phone = data["phone"];
    final timeMills = data["time_mills"];
    final cameraOn = data["isCameraOn"];
    final mute = data["isMute"];
    final riseHand = data["handUp"];
    return MeetingContributor(
      id: id is String ? id : "",
      timeMills: timeMills is int ? timeMills : 0,
      email: email is String ? email : "",
      name: name is String ? name : "",
      phone: phone is String ? phone : "",
      photo: photo is String ? photo : "",
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
      "email": email,
      "name": name,
      "phone": phone,
      "photo": photo,
    };
  }
}
