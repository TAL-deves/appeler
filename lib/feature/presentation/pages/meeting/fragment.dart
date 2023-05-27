import 'dart:async';

import 'package:appeler/feature/presentation/pages/meeting/local_user.dart';
import 'package:appeler/feature/presentation/pages/meeting/meeting_view.dart';
import 'package:appeler/feature/presentation/pages/meeting/remote_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_andomie/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../../index.dart';

class MeetingFragment extends StatefulWidget {
  final MeetingInfo info;

  const MeetingFragment({
    super.key,
    required this.info,
  });

  @override
  State<MeetingFragment> createState() => MeetingFragmentState();
}

class MeetingFragmentState extends State<MeetingFragment> {
  late final controller = context.read<MeetingController>();
  late bool isCameraOn = widget.info.isCameraOn;
  late bool isMute = widget.info.isMuted;
  late bool isFrontCamera = widget.info.isFrontCamera;
  late SizeConfig config = SizeConfig.of(context, size: Size.zero);
  bool isRiseHand = false;
  bool isReserveMode = true;
  int crossAxisCount = 2;

  final _localRenderer = RTCVideoRenderer();
  MediaStream? _localStream;

  final _keyMap = <String, GlobalKey>{};
  final _widgetMap = <String, Widget>{};
  final _addedUser = <String>{};

  StreamSubscription? _roomSubs, _hostSubs;

  Future<MediaStream> get _getUserMediaStream async {
    final mp = <String, dynamic>{
      'audio': true,
      'video': kIsWeb
          ? {'facingMode': 'user'}
          : {
              'width': '320',
              'height': '240',
              'frameRate': '30',
              'facingMode': 'user',
              'optional': [],
            }
    };
    final stream = await navigator.mediaDevices.getUserMedia(mp);
    return stream;
  }

  @override
  void initState() {
    _initLocalRenderer();
    super.initState();
  }

  void _initLocalRenderer() async {
    await _localRenderer.initialize();
    _localStream = await _getUserMediaStream;
    onCameraOn(isCameraOn);
    onMute(isMute);
    onSwitchCamera(!widget.info.isFrontCamera);
    setState(() {
      _localRenderer.srcObject = _localStream;
      _widgetMap['local'] = ContributorCard(
        key: UniqueKey(),
        renderer: _localRenderer,
        meetingId: widget.info.id,
        uid: AuthHelper.uid,
      );
    });
    _setStatus();
    _offerAnswerHostUser();
  }

  void onCameraOn(bool value) {
    isCameraOn = value;
    if (_localStream != null) {
      _localStream?.getVideoTracks()[0].enabled = isCameraOn;
      _changeStatus(key: 'isCameraOn');
    }
  }

  void onMute(bool value) {
    isMute = value;
    if (_localStream != null) {
      _localStream?.getAudioTracks()[0].enabled = !isMute;
      _changeStatus(key: 'isMute');
    }
  }

  void onSilent(bool value) => Helper.setSpeakerphoneOn(!value);

  void onSwitchCamera(bool value) {
    if (_localStream != null && value) {
      Helper.switchCamera(_localStream!.getVideoTracks()[0]);
    }
  }

  void onMore(bool value) {}

  void onRiseHand(bool value) {
    isRiseHand = value;
    _changeStatus(key: 'handUp');
  }

  void _offerAnswerHostUser() {
    _hostSubs = controller.handler
        .getMeetingReference(widget.info.id)
        .snapshots()
        .listen((event) {
      final mp = event.data();
      if (mp != null && mp is Map<String, dynamic>) {
        for (final item in mp.entries) {
          final curItem = item.key;
          if (curItem != AuthHelper.uid && !_addedUser.contains(curItem)) {
            final newKey = GlobalKey();
            _keyMap[curItem] = newKey;
            _addedUser.add(curItem);
            _widgetMap[curItem] = RemoteContributor(
              key: newKey,
              type: AuthHelper.uid.compareTo(curItem) > 0
                  ? ContributorType.outgoing
                  : ContributorType.incoming,
              uid: curItem,
              meetingId: widget.info.id,
              local: _localStream!,
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
          _keyMap.remove(item);
          _widgetMap.remove(item);
        }
        setState(() {});
      }
    });
  }

  void _changeStatus({required String key}) {
    controller.handler.changeStatus(
      id: widget.info.id,
      isMute: isMute,
      isRiseHand: isRiseHand,
      isCameraOn: isCameraOn,
      isFrontCamera: isFrontCamera,
    );
  }

  void _setStatus() {
    controller.handler.setStatus(
      id: widget.info.id,
      isMute: isMute,
      isRiseHand: isRiseHand,
      isCameraOn: isCameraOn,
      isFrontCamera: isFrontCamera,
    );
  }

  void _removeStatus() {
    controller.handler.removeStatus(widget.info.id);
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
          child: MeetingView(
            config: config,
            items: children,
            itemBackground: Colors.black.withAlpha(50),
            itemSpace: 5,
            frameBuilder: (context, layer, item) {
              return item;
            },
          ),
        ),
        MeetingControls(
          activeColor: AppColors.secondary,
          inactiveColor: AppColors.secondary.withAlpha(25),
          activeIconColor: Colors.white,
          inactiveIconColor: AppColors.secondary,
          isCameraOn: isCameraOn,
          isFrontCamera: widget.info.isFrontCamera,
          isMuted: isMute,
          isRiseHand: isRiseHand,
          isSilent: widget.info.isSilent,
          onCameraOn: onCameraOn,
          onMute: onMute,
          onMore: onMore,
          onRiseHand: onRiseHand,
          onSilent: onSilent,
          onSwitchCamera: onSwitchCamera,
          onCancel: (context) => Navigator.pop(context),
          cancelProperty: const ButtonProperty(
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
    _disposeSubs();
    _removeStatus();
    _disposeLocalRenderer();
    super.dispose();
  }

  void _disposeLocalRenderer() {
    _localRenderer.dispose();
    _localStream?.getTracks().forEach((element) {
      element.stop();
    });
    _localStream?.dispose();
  }

  void _disposeSubs() {
    _hostSubs?.cancel();
    _roomSubs?.cancel();
  }
}
