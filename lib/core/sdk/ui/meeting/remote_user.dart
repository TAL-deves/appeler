import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy/widgets.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../analytica_rtc.dart';
import 'call_enum.dart';
import 'contents/contributor_view.dart';

class _ApiManager {
  final int seconds;
  Timer? _timer;
  final _curData = <String, dynamic>{};
  final String selfCandidatePath;

  _ApiManager({required this.seconds, required this.selfCandidatePath});

  void _add({required String key, required Map<String, dynamic> value}) {
    _timer?.cancel();
    _curData.addAll({key: value});
    _timer = Timer(Duration(seconds: seconds), () {
      AnalyticaRTC.repository
          .update(path: selfCandidatePath, data: _curData)
          .then((value) {
        Future.delayed(const Duration(seconds: 2)).then((value) {
          AnalyticaRTC.repository.emitOnSocket(path: selfCandidatePath);
        });
      });
    });
  }
}

class ARTCRemoteContributor extends StatefulWidget {
  final void Function(RTCVideoRenderer renderer, bool isMirroring)? onZoom;
  final String uid;
  final String remoteUid;
  final String meetingId;
  final MediaStream localStream;
  final ARTCContributorType type;
  final MediaStream? shareStream;

  final bool micOn, cameraOn, isMirror;

  const ARTCRemoteContributor({
    super.key,
    this.onZoom,
    required this.uid,
    this.remoteUid = "",
    required this.meetingId,
    required this.localStream,
    required this.type,
    this.shareStream,
    this.cameraOn = false,
    this.micOn = false,
    this.isMirror = false,
  });

  @override
  State<ARTCRemoteContributor> createState() => ARTCRemoteContributorState();
}

class ARTCRemoteContributorState extends State<ARTCRemoteContributor> {
  late RealTimeDB _listenOfferAnswer, _listenRemoteCandidate;

  late final _apiManager =
      _ApiManager(seconds: 3, selfCandidatePath: _selfCandidatePath);
  late final String _prePath =
      '${widget.meetingId}/${widget.type == ARTCContributorType.outgoing ? '${widget.uid}+${widget.remoteUid}' : '${widget.remoteUid}+${widget.uid}'}';
  late final String _offerAnswerPath = '$_prePath/offerAnswer';
  late final String _selfCandidatePath =
      '$_prePath/${widget.type == ARTCContributorType.outgoing ? 'callerCandidate' : 'callieCandidate'}';
  late final String _remoteCandidatePath =
      '$_prePath/${widget.type == ARTCContributorType.outgoing ? 'callieCandidate' : 'callerCandidate'}';

  MediaStream? _remoteStream;
  late RTCPeerConnection _peerConnection;

  final _remoteRenderer = RTCVideoRenderer();

  var totalCandidate = 0;

  final _addedCandidate = <String>{};
  var _candidateId = 0;

  late var _innerMicOn = widget.micOn;
  late var _innerCameraOn = widget.cameraOn;
  late var _isMirror = widget.isMirror;

  void replaceVideoStream(MediaStream foreignStream) {
    _peerConnection.getSenders().then((value) {
      for (final element in value) {
        if (element.track?.kind == 'video') {
          element.replaceTrack(foreignStream.getVideoTracks()[0]).then((value) {
            if (kDebugMode) {
              print('Track replaced !');
            }
          }).catchError((error) {
            if (kDebugMode) {
              print(error);
            }
          });
        }
      }
    });
  }

  void _setRemoteCandidate() {
    _listenRemoteCandidate = AnalyticaRTC.getRealTimeDB(
        path: _remoteCandidatePath,
        onGetData: (value) {
          final curMap = value['data'] as Map<String, dynamic>?;
          if (curMap != null) {
            for (final item in curMap.entries) {
              if (!_addedCandidate.contains(item.key)) {
                _addedCandidate.add(item.key);
                ++totalCandidate;
                final curData = item.value as Map<String, dynamic>;
                final candidate = RTCIceCandidate(curData['candidate'],
                    curData['sdpMid'], curData['sdpMLineIndex']);
                _peerConnection.addCandidate(candidate);
              }
            }
          }
        });
  }

  Future<void> _initRemoteRenderer() async {
    await _remoteRenderer.initialize();
  }

  Future<void> _disposeRemoteRenderer() async {
    _remoteRenderer.dispose();
    _remoteStream?.getTracks().forEach((track) {
      track.stop();
    });
    _remoteStream?.dispose();
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    final config = <String, dynamic>{
      //"sdpSemantics": "plan-b",
      'iceServers': [
        {
          //"urls": "turn:147.182.180.252:3478",
          "urls": "turn:coturnserver.techanalyticaltd.com",
          "username": "tal",
          "credential": "t0a3l2"
        }
      ]
    };

    final pc = await createPeerConnection(config);

    //pc.addStream(widget.localStream);
    widget.localStream.getTracks().forEach((track) {
      pc.addTrack(track, widget.localStream);
    });

    await AnalyticaRTC.repository.set(path: _selfCandidatePath, data: {});

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        _apiManager._add(key: '${++_candidateId}', value: e.toMap());
        //AnalyticaRTC.repository.update(path: _selfCandidatePath, data: { '${++_candidateId}': e.toMap() });
      }
    };

    pc.onAddStream = (stream) {
      setState(() {
        _remoteRenderer.srcObject = stream;
        _remoteStream = stream;
      });
    };
    return pc;
  }

  Future<void> _initPeerConnection() async {
    _peerConnection = await _createPeerConnection();
  }

  Future<void> _setRemoteDescription(
      {required Map<String, dynamic> sdpMap}) async {
    final description = RTCSessionDescription(sdpMap['sdp'], sdpMap['type']);
    return await _peerConnection.setRemoteDescription(description);
  }

  void _createOffer() async {
    final offer = await _peerConnection.createOffer();
    await _peerConnection.setLocalDescription(offer);
    _listenOfferAnswer = AnalyticaRTC.getRealTimeDB(
        path: _offerAnswerPath,
        onGetData: (value) async {
          final sdpMap = value['data']?['answer'];
          if (await _peerConnection.getRemoteDescription() == null &&
              sdpMap != null) {
            await _setRemoteDescription(sdpMap: sdpMap);
          }
        });
    AnalyticaRTC.repository.set(
        path: _offerAnswerPath, data: {'offer': offer.toMap()}).then((value) {
      Future.delayed(const Duration(seconds: 2)).then((value) {
        AnalyticaRTC.repository.emitOnSocket(path: _offerAnswerPath);
      });
    });
  }

  void _createAnswer() async {
    _listenOfferAnswer = AnalyticaRTC.getRealTimeDB(
        path: _offerAnswerPath,
        onGetData: (value) async {
          final sdpMap = value['data']?['offer'];
          if (await _peerConnection.getRemoteDescription() == null &&
              sdpMap != null) {
            await _setRemoteDescription(sdpMap: sdpMap);
            final answer = await _peerConnection.createAnswer();
            await _peerConnection.setLocalDescription(answer);
            AnalyticaRTC.repository
                .set(path: _offerAnswerPath, data: {'answer': answer.toMap()});
          }
        });
  }

  void _disposeListeners() {
    _listenOfferAnswer.dispose();
    _listenRemoteCandidate.dispose();
  }

  void _initRendererOfferAnswer() async {
    await _initRemoteRenderer();
    await _initPeerConnection();
    _setRemoteCandidate();
    if (widget.type == ARTCContributorType.outgoing) {
      _createOffer();
    } else {
      _createAnswer();
    }
  }

  void _deleteSelfCandidate() {
    AnalyticaRTC.repository.delete(path: _selfCandidatePath).then((value) {
      log('self candidate deleted successfully!');
    });
  }

  void _deleteOfferAnswer() {
    AnalyticaRTC.repository.delete(path: _offerAnswerPath).then((value) {
      log('Offer Answer deleted successfully!');
    });
  }

  void _allDispose() async {
    _disposeListeners();
    _disposeRemoteRenderer();
    _deleteSelfCandidate();
    _deleteOfferAnswer();
    _peerConnection.close();
  }

  void flagsUpdate({
    required bool isCameraOn,
    required bool isMicOn,
    required bool isMirror,
  }) {
    setState(() {
      _innerMicOn = isMicOn;
      _innerCameraOn = isCameraOn;
      _isMirror = isMirror;
    });
  }

  @override
  void initState() {
    _initRendererOfferAnswer();
    Future.delayed(const Duration(seconds: 10)).then((value) {
      if (kDebugMode) {
        print('total candidate is: $totalCandidate');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _allDispose();
    log('dispose is called with user id: ${widget.uid}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ARTCContributorView(
      renderView: GestureDetector(
        onTap: () => widget.onZoom?.call(_remoteRenderer, _isMirror),
        child: AbsorbPointer(
          child: RTCVideoView(
            _remoteRenderer,
            objectFit: _isMirror
                ? RTCVideoViewObjectFit.RTCVideoViewObjectFitCover
                : RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
            //mirror: kIsWeb ? !_isMirror : _isMirror,
            mirror: _isMirror,
            key: UniqueKey(),
          ),
        ),
      ),
      item: ARTCContributor(
        cameraOn: _innerCameraOn,
        muted: !_innerMicOn,
      ),
      userView: (context, item) {
        var photo = item?.photo ??
            "https://assets.materialup.com/uploads/b78ca002-cd6c-4f84-befb-c09dd9261025/preview.png";
        var name = item?.name ?? item?.email ?? "Unknown";
        return LinearLayout(
          layoutGravity: LayoutGravity.center,
          children: [
            ImageView(
              width: 80,
              height: 80,
              shape: ViewShape.circular,
              image: photo.isValid
                  ? photo
                  : "https://assets.materialup.com/uploads/b78ca002-cd6c-4f84-befb-c09dd9261025/preview.png",
              scaleType: BoxFit.cover,
            ),
            TextView(
              paddingHorizontal: 16,
              text: name.isValid ? name : item?.email ?? "Unknown",
              textOverflow: TextOverflow.ellipsis,
              textSize: 14,
              textColor: Colors.black.withOpacity(0.8),
              textFontWeight: FontWeight.bold,
              marginTop: 8,
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
