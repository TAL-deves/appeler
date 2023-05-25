import '../../../../index.dart';

class MeetingInfo {
  String id;
  bool isCameraOn;
  bool isMuted;
  bool isSilent;
  bool isShareScreen;
  CameraType cameraType;

  bool get isFrontCamera => cameraType == CameraType.front;

  MeetingInfo({
    required this.id,
    this.isCameraOn = true,
    this.isMuted = false,
    this.isSilent = false,
    this.cameraType = CameraType.front,
    this.isShareScreen = false,
  });

  MeetingInfo attach({
    String? id,
    bool? isCameraOn,
    bool? isMuted,
    bool? isSilent,
    bool? isShareScreen,
    CameraType? cameraType,
  }) {
    return MeetingInfo(
      id: id ?? this.id,
      isCameraOn: isCameraOn ?? this.isCameraOn,
      isMuted: isMuted ?? this.isMuted,
      isSilent: isSilent ?? this.isSilent,
      cameraType: cameraType ?? this.cameraType,
      isShareScreen: isShareScreen ?? this.isShareScreen,
    );
  }

  @override
  String toString() {
    return "MeetingInfo ($id, $isCameraOn, $isMuted, $isSilent, $cameraType, $isShareScreen)";
  }
}
