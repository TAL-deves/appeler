import '../../../../index.dart';

class ARTCMeetingInfo {
  String roomId;
  String currentUid;
  String? email;
  String? name;
  String? phone;
  String? photo;
  bool isCameraOn;
  bool isMuted;
  bool isSilent;
  bool isShareScreen;
  CameraType cameraType;

  bool get isFrontCamera => cameraType == CameraType.front;

  ARTCMeetingInfo({
    required this.roomId,
    required this.currentUid,
    this.isCameraOn = true,
    this.isMuted = false,
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
    bool? isMuted,
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
      isMuted: isMuted ?? this.isMuted,
      isSilent: isSilent ?? this.isSilent,
      cameraType: cameraType ?? this.cameraType,
      isShareScreen: isShareScreen ?? this.isShareScreen,
    );
  }

  @override
  String toString() {
    return "MeetingInfo (roomId: $roomId, currentUid: $currentUid, email: $email, name: $name, phone: $phone, photo: $photo, isCameraOn: $isCameraOn, isMuted: $isMuted, isSilent: $isSilent, cameraType: $cameraType, isShareScreen: $isShareScreen)";
  }
}
