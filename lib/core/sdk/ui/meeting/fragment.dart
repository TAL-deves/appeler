import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ed_screen_recorder/ed_screen_recorder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy/extensions.dart';
import 'package:flutter_androssy/widgets.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../analytica_rtc.dart';
import '../../socket_connection.dart';
import '../../use_cases.dart';
import '../widgets/tile_button.dart';
import 'call_enum.dart';
import 'contents/contributor_view.dart';
import 'contents/meeting_controls.dart';
import 'drawing_board.dart';
import 'local_user.dart';
import 'meeting_info.dart';
import 'meeting_view.dart';
import 'remote_user.dart';

class ARTCMeetingSegment extends StatefulWidget {
  final ARTCMeetingInfo info;

  const ARTCMeetingSegment({
    super.key,
    required this.info,
  });

  @override
  State<ARTCMeetingSegment> createState() => ARTCMeetingSegmentState();
}

class ARTCMeetingSegmentState extends State<ARTCMeetingSegment> {
  final _repository = AnalyticaRTC.repository;
  late RealTimeDB socketRoomListen;

  final _localRenderer = RTCVideoRenderer();
  MediaStream? _localStream, _shareStream;

  final _widgetMap = <String, Widget>{};
  final _keyMap = <String, GlobalKey>{};
  final _addedUser = <String>{};

  EdScreenRecorder? screenRecorder;
  Map<String, dynamic>? _response;

  StreamSubscription? _subs;

  var _micOn = true, _cameraOn = true;

  late final String _tempPath;

  var _screenShareIsOn = false;

  var _whiteBoardIsOn = false;

  final _whiteKey = GlobalKey();

  final _whiteKey2 = GlobalKey();

  Uint8List? _localList, _remoteList;

  Timer? _timer, _timer2;

  late final RealTimeDB _listenOnImageList;

  void _replaceVideoStreamOnRemotes(MediaStream stream) {
    for (final item in _keyMap.values) {
      final curItemState = item.currentState as ARTCRemoteContributorState?;
      curItemState?.replaceVideoStream(stream);
    }
  }

  void _setScreenShareStream() async {
    try {
      _shareStream = await _getShareStream;
      if (_shareStream != null) {
        _replaceVideoStreamOnRemotes(_shareStream!);
        _screenShareIsOn = true;
        _changeStatus();
      } else {
        _shareStream = null;
        _screenShareIsOn = false;
      }
    } catch (e) {
      _shareStream = null;
      _screenShareIsOn = false;
    }
  }

  void _recoverCameraStream() async {
    _replaceVideoStreamOnRemotes(_localStream!);
    _shareStream?.getTracks().forEach((element) {
      element.stop();
    });
    _shareStream?.dispose();
    _shareStream = null;
  }

  Future<MediaStream> get _getShareStream async {
    return navigator.mediaDevices.getDisplayMedia(_streamConfig);
  }

  Future<void> startRecord({required String fileName}) async {
    try {
      var startResponse = await screenRecorder?.startRecordScreen(
        fileName: fileName,
        //Optional. It will save the video there when you give the file path with whatever you want.
        //If you leave it blank, the Android operating system will save it to the gallery.
        dirPathToSave: _tempPath,
        audioEnable: true,
      );
      _response = startResponse;
      if (kDebugMode) {
        print('start response is : $_response');
      }
    } on PlatformException {
      kDebugMode
          ? debugPrint("Error: An error occurred while starting the recording!")
          : null;
    }
  }

  Future<void> stopRecord() async {
    try {
      var stopResponse = await screenRecorder?.stopRecord();
      _response = stopResponse;
      if (kDebugMode) {
        print('stop response is : $_response');
      }
    } on PlatformException {
      kDebugMode
          ? debugPrint("Error: An error occurred while stopping recording.")
          : null;
    }
  }

  Future<void> pauseRecord() async {
    try {
      await screenRecorder?.pauseRecord();
    } on PlatformException {
      kDebugMode
          ? debugPrint("Error: An error occurred while pause recording.")
          : null;
    }
  }

  Future<void> resumeRecord() async {
    try {
      await screenRecorder?.resumeRecord();
    } on PlatformException {
      kDebugMode
          ? debugPrint("Error: An error occurred while resume recording.")
          : null;
    }
  }

  final _streamConfig = <String, dynamic>{
    'audio': true,
    'video': {
      'width': 320 * 2,
      'height': 240 * 2,
      'frameRate': 30,
      'facingMode': 'user',
      //'optional': [],
    }
  };

  Future<MediaStream> get _getUserMediaStream async {
    final stream = await navigator.mediaDevices.getUserMedia(_streamConfig);
    return stream;
  }

  void _changeStatus({String? key}) {
    _repository.update(
      path: widget.info.roomId,
      data: {
        widget.info.currentUid: {
          'isMirror': !_screenShareIsOn,
          'isMicrophoneOn': _isMicrophoneOn,
          'isCameraOn': isCameraOn,
          'isFrontCamera': isFrontCamera,
          'isRiseHand': isRiseHand,
          'meetingId': widget.info.roomId,
          'uid': widget.info.currentUid,
          'email': widget.info.email,
          'name': widget.info.name,
          'photo': widget.info.photo,
          'phone': widget.info.phone,
          'whiteboard': _whiteBoardIsOn,
        },
      },
    );
  }

  void _removeCurrentRoom() {
    deleteRoomUseCase.deleteRoom(roomId: widget.info.roomId).then((value) {
      log('room delete: $value');
    });
    _repository.delete(path: widget.info.roomId);
  }

  void _removeCurrentUser() {
    _repository.read(path: widget.info.roomId).then((value) {
      final curMap = value['data'] as Map<String, dynamic>?;
      if (curMap != null) {
        if (curMap.length == 1) {
          _removeCurrentRoom();
        } else {
          curMap.remove(widget.info.currentUid);
          _repository.set(path: widget.info.roomId, data: curMap);
        }
      }
    });
  }

  void _initLocalRenderer() async {
    await _localRenderer.initialize();
    _localStream = await _getUserMediaStream;
    setState(() {
      _localRenderer.srcObject = _localStream;
      final newKey = GlobalKey();
      _keyMap['local'] = newKey;
      _widgetMap['local'] = ARTCContributorCard(
        key: newKey,
        renderer: _localRenderer,
        meetingId: widget.info.roomId,
        uid: widget.info.currentUid,
        mirror: true,
        contributor: ARTCContributor(
          isCameraOn: isCameraOn,
          isMicrophoneOn: _isMicrophoneOn,
          isRiseHand: isRiseHand,
          isShareScreen: _screenShareIsOn,
        ),
      );
      onMicrophoneEnable(_isMicrophoneOn);
    });
    _changeStatus();
    _offerAnswerHostUser();
  }

  void _flagStateUpdate(Map<String, dynamic>? mp) {
    if (mp != null) {
      for (final item in mp.entries) {
        final curValue = item.value;
        (_keyMap[item.key]?.currentState as ARTCRemoteContributorState?)
            ?.flagsUpdate(
          isCameraOn: curValue['isCameraOn'],
          isMicrophoneOn: curValue['isMicrophoneOn'],
          isRiseHand: curValue['isRiseHand'],
          isMirror: curValue['isMirror'],
        );
      }
    }
  }

  void _addCurUserToWhiteBoard({required String userId}) {
    final curState = _whiteKey.currentState as ARTCDrawingBoardState?;
    curState?.addNewUser(userId: userId);
    _changeStatus();
  }

  void _offerAnswerHostUser() {
    socketRoomListen = AnalyticaRTC.getRealTimeDB(
      path: widget.info.roomId,
      onGetData: (value) {
        final mp = value['data'] as Map<String, dynamic>?;
        if (mp != null) {
          for (final item in mp.entries) {
            final curItem = item.key;
            if (curItem != widget.info.currentUid &&
                !_addedUser.contains(curItem)) {
              _addedUser.add(curItem);
              _addCurUserToWhiteBoard(userId: curItem);
              var isMirror = item.value['isMirror'];
              final newKey = GlobalKey();
              _keyMap[curItem] = newKey;
              _widgetMap[curItem] = ARTCRemoteContributor(
                key: newKey,
                type: widget.info.currentUid.compareTo(curItem) > 0
                    ? ARTCContributorType.outgoing
                    : ARTCContributorType.incoming,
                uid: widget.info.currentUid,
                remoteUid: curItem,
                localStream: _shareStream ?? _localStream!,
                meetingId: widget.info.roomId,
                isCameraOn: item.value['isCameraOn'],
                isMicrophoneOn: item.value['isMicrophoneOn'],
                isRiseHand: item.value['isRiseHand'],
                isMirror: isMirror,
                onZoom: (renderer, isMirroring) async {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      return Scaffold(
                        backgroundColor: Colors.black,
                        appBar: AppBar(
                          backgroundColor: Colors.white12,
                          leading: IconButton(
                            splashColor: Colors.white12,
                            splashRadius: 40,
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.white54,
                            ),
                          ),
                          title: const Text(
                            "Screen sharing...",
                            style: TextStyle(
                              color: Colors.white54,
                            ),
                          ),
                        ),
                        body: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(
                            child: RTCVideoView(
                              renderer,
                              key: UniqueKey(),
                              mirror: isMirroring,
                              objectFit: isMirroring
                                  ? RTCVideoViewObjectFit
                                      .RTCVideoViewObjectFitCover
                                  : RTCVideoViewObjectFit
                                      .RTCVideoViewObjectFitContain,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }
          }
          final list = <String>[];
          for (final item in _widgetMap.entries) {
            if (item.key != 'local' && !mp.containsKey(item.key)) {
              list.add(item.key);
            }
          }
          for (final item in list) {
            _addedUser.remove(item);
            _widgetMap.remove(item);
            _keyMap.remove(item);
          }
          setState(() {
            _flagStateUpdate(mp);
          });
        }
      },
    );
  }

  void _disposeLocalRenderer() {
    _localRenderer.dispose();
    _localStream?.getTracks().forEach((element) {
      element.stop();
    });
    _localStream?.dispose();
  }

  void _joinLeave(int type) {
    joinLeaveRoomUseCase
        .joinLeaveRoom(
            roomId: widget.info.roomId,
            userId: widget.info.currentUid,
            type: type)
        .then((value) {
      log('form live: $value');
    });
  }

  void _initList() {
    _listenOnImageList = AnalyticaRTC.getRealTimeDB(
        path: '${widget.info.roomId}/imageByte',
        onGetData: (data) {
          final curData = data['data']?['bytes'];
          if (curData != null) {
            setState(() {
              _remoteList = Uint8List.fromList(List<int>.from(curData));
            });
          }
        });
  }

  late bool isCameraOn = widget.info.isCameraOn;
  late bool _isMicrophoneOn = widget.info.isMicrophoneOn;
  late bool isFrontCamera = widget.info.isFrontCamera;
  late bool isShareScreen = widget.info.isShareScreen;
  late SizeConfig config = SizeConfig.of(context, size: Size.zero);
  bool isRiseHand = false;
  bool isReserveMode = true;
  int crossAxisCount = 2;

  @override
  void initState() {
    super.initState();
    _initList();
    _initLocalRenderer();
    _joinLeave(0);
    super.initState();
    screenRecorder = EdScreenRecorder();
    SocketConnection.socket.on('roomclosed:${widget.info.roomId}', (data) {
      _repository.delete(path: widget.info.roomId);
      Navigator.pop(context);
    });
  }

  void onCameraOn(bool value) {
    isCameraOn = value;
    if (_localStream != null) {
      _localStream?.getVideoTracks()[0].enabled = isCameraOn;
      _changeStatus(key: 'isCameraOn');
    }
    setState(() {});
  }

  void onMicrophoneEnable(bool value) {
    _isMicrophoneOn = value;
    if (_localStream != null && _localStream!.getAudioTracks().isNotEmpty) {
      _localStream?.getAudioTracks()[0].enabled = _isMicrophoneOn;
      _changeStatus(key: 'isMicrophoneOn');
    }
  }

  void onSilent(bool value) => Helper.setSpeakerphoneOn(!value);

  void onSwitchCamera(bool value) {
    if (_localStream != null && value) {
      Helper.switchCamera(_localStream!.getVideoTracks()[0]);
    }
  }

  void onMore(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return LinearLayout(
          paddingVertical: 24,
          children: [
            LinearLayout(
              paddingStart: 24,
              paddingEnd: 16,
              orientation: Axis.horizontal,
              mainGravity: MainAxisAlignment.center,
              paddingBottom: 8,
              children: [
                const TextView(
                  flex: 1,
                  text: "Choose options",
                  textAlign: TextAlign.start,
                  textColor: Colors.grey,
                  textSize: 16,
                ),
                IconView(
                  padding: 4,
                  size: 40,
                  icon: Icons.clear,
                  onClick: (context) => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(
              height: 12,
            ),
            TileButton(
              text: isRiseHand ? "Hands down" : "Hands up",
              icon: Icons.back_hand_outlined,
              onClick: (context) {
                onRiseHand(!isRiseHand);
                Navigator.pop(context);
              },
            ),
            TileButton(
              text: "Make Whiteboard",
              icon: Icons.draw,
              onClick: (context) {
                onShareBoard(context);
                Navigator.pop(context);
              },
            ),
            TileButton(
              text: "Code copy",
              icon: Icons.copy,
              onClick: (context) {
                onCodeCopy(context);
                //Navigator.pop(context);
              },
            ),
            TileButton(
              text: "Code share",
              icon: Icons.share,
              onClick: (context) {
                //onCopyOrShare(widget.info.roomId, context);
                //Navigator.pop(context);
              },
            ),
            TileButton(
              icon: Icons.arrow_forward_ios_sharp,
              iconSize: 24,
              tint: Colors.grey,
              text: "Show participants",
              onClick: (context) {
                onShowParticipant(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void onRiseHand(bool value) {
    isRiseHand = value;
    _changeStatus(key: 'isRiseHand');
    setState(() {});
  }

  void onScreenShare(bool value) {
    if (!kIsWeb && Platform.isIOS) {
      Fluttertoast.showToast(msg: "Screen share isn't process in iOS device!");
    } else {
      if (value) {
        _setScreenShareStream();
      } else {
        _screenShareIsOn = false;
        _recoverCameraStream();
        _changeStatus();
      }
    }
    setState(() {});
  }

  void onCodeCopy(BuildContext context) async {
    if (widget.info.roomId.isValid) {
      final curValue = widget.info.roomId;
      await ClipboardHelper.setText(curValue);
      Fluttertoast.showToast(msg: curValue);
    }
  }

  void onShareBoard(BuildContext context) {
    _whiteBoardIsOn = !_whiteBoardIsOn;
    _changeStatus();
    setState(() {});
  }

  void onShowParticipant(BuildContext context) {
    if (kIsWeb) {
      Fluttertoast.showToast(msg: "Web not supported!");
    } else {
      // AppCurrentNavigator.of(context).go(
      //   MeetingParticipantActivity.route.withParent("app"),
      //   extra: {
      //     "MeetingController": controller,
      //     "meeting_id": widget.info.roomId,
      //   },
      // );
    }
  }

  int get snapCount {
    switch (itemCount) {
      case 1:
        return 1;
      case 2:
        return 2;
      case 3:
        return config.isMobile ? 2 : 3;
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
        return config.isMobile
            ? 2
            : config.isTab
                ? 3
                : 4;
      default:
        return config.isMobile
            ? 2
            : config.isTab
                ? 3
                : config.isLaptop
                    ? 4
                    : config.isDesktop
                        ? 5
                        : 6;
    }
  }

  List<Widget> get children {
    return _widgetMap.entries.map((e) => e.value).toList();
  }

  Widget childAt(int index) {
    return children[index];
  }

  double get ratio {
    switch (itemCount) {
      case 1:
        return 0.6;
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    config = SizeConfig.of(context);
    return LinearLayout(
      width: double.infinity,
      height: double.infinity,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: itemCount > 1 ? const EdgeInsets.all(16) : null,
            child: ARTCMeetingView(
              config: config,
              items: children,
              itemBackground: Colors.black.withAlpha(50),
              itemSpace: 16,
              frameBuilder: (context, layer, item) {
                return item;
              },
            ),
          ),
        ),
        if (_whiteBoardIsOn)
          ARTCDrawingBoard(
            key: _whiteKey,
            writeMode: true,
            roomId: widget.info.roomId,
            userId: widget.info.currentUid,
            onCloseWhiteBoard: () {
              setState(() => _whiteBoardIsOn = false);
            },
          )
        else
          ARTCDrawingBoard(
            key: _whiteKey2,
            writeMode: false,
            roomId: widget.info.roomId,
            userId: widget.info.currentUid,
            onCloseWhiteBoard: () {
              setState(() => _whiteBoardIsOn = false);
            },
          ),
        ARTCMeetingControls(
          activeColor: context.primaryColor,
          inactiveColor: context.primaryColor.withAlpha(25),
          activeIconColor: Colors.white,
          inactiveIconColor: context.primaryColor,
          isCameraOn: isCameraOn,
          isFrontCamera: widget.info.isFrontCamera,
          isMicrophoneEnabled: _isMicrophoneOn,
          isRiseHand: isRiseHand,
          isSilent: widget.info.isSilent,
          isScreenShared: _screenShareIsOn,
          onCameraOn: onCameraOn,
          onMicrophone: onMicrophoneEnable,
          onMore: onMore,
          onScreenShare: onScreenShare,
          onRiseHand: onRiseHand,
          onSilent: onSilent,
          onSwitchCamera: onSwitchCamera,
          onCancel: (context) => Navigator.pop(context),
          //AppCurrentNavigator.of(context).goBack(),
          cancelProperty: const ARTCButtonProperty(
            tint: Colors.red,
            background: Colors.transparent,
            size: 40,
            padding: 0,
            icon: Icons.call_end_rounded,
            splashColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

  int get itemCount => children.length;

  bool get isVerticalMode => config.width < config.height && config.isMobile;

  @override
  void dispose() {
    _listenOnImageList.dispose();
    _subs?.cancel();
    _disposeLocalRenderer();
    socketRoomListen.dispose();
    _removeCurrentUser();
    _joinLeave(1);
    SocketConnection.socket.off('roomclosed:${widget.info.roomId}');
    super.dispose();
  }
}
