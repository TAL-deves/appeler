import '../../../../index.dart';

class ARTCMeetingInfo {
  String roomId;
  String currentUid;
  String? email;
  String? name;
  String? phone;
  String? photo;
  bool isCameraOn;
  bool isMicrophoneOn;
  bool isSilent;
  bool isShareScreen;
  CameraType cameraType;

  bool get isFrontCamera => cameraType == CameraType.front;

  ARTCMeetingInfo({
    required this.roomId,
    required this.currentUid,
    this.isCameraOn = true,
    this.isMicrophoneOn = false,
    this.isSilent = false,
    this.cameraType = CameraType.front,
    this.isShareScreen = false,
    this.email,
    this.name,
    this.phone,
    this.photo,
  });

  ARTCMeetingInfo attach({
    String? roomId,
    String? currentUid,
    String? email,
    String? name,
    String? phone,
    String? photo,
    bool? isCameraOn,
    bool? isMicrophoneOn,
    bool? isSilent,
    bool? isShareScreen,
    CameraType? cameraType,
  }) {
    return ARTCMeetingInfo(
      roomId: roomId ?? this.roomId,
      currentUid: currentUid ?? this.currentUid,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      isCameraOn: isCameraOn ?? this.isCameraOn,
      isMicrophoneOn: isMicrophoneOn ?? this.isMicrophoneOn,
      isSilent: isSilent ?? this.isSilent,
      cameraType: cameraType ?? this.cameraType,
      isShareScreen: isShareScreen ?? this.isShareScreen,
    );
  }

  @override
  String toString() {
    return "MeetingInfo (roomId: $roomId, currentUid: $currentUid, email: $email, name: $name, phone: $phone, photo: $photo, isCameraOn: $isCameraOn, isMicrophoneOn: $isMicrophoneOn, isSilent: $isSilent, cameraType: $cameraType, isShareScreen: $isShareScreen)";
  }
}
