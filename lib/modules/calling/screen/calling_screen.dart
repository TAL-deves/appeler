import 'dart:async';
import 'package:appeler/core/app_constants/app_color.dart';
import 'package:appeler/core/widgets/app_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../auth/api/auth_management.dart';
import 'call_enum/call_enum.dart';

const callingScreenRoute = 'callingScreenRoute';

class CallingScreen extends StatefulWidget {
  const CallingScreen({super.key, required this.id, required this.callEnum});

  final String id;
  final CallEnum callEnum;

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  final _chatRooms = FirebaseFirestore.instance.collection('chat-rooms');
  final _curUser = FirebaseFirestore.instance.collection('users').doc(AuthManagementUseCase.curUser);
  late final _curRoom = _chatRooms.doc(
    widget.callEnum == CallEnum.outgoing
        ? '${AuthManagementUseCase.curUser}+${widget.id}'
        : '${widget.id}+${AuthManagementUseCase.curUser}'
  );

  CollectionReference<Map<String, dynamic>>? _roomInnerCollection;

  StreamSubscription? _roomSubs;

  final _localRenderer = RTCVideoRenderer();
  //final _remoteRenderer = RTCVideoRenderer();
  late MediaStream _localStream;
  late RTCPeerConnection _peerConnection;

  StreamSubscription? _curRoomSubs;

  Future<MediaStream> get _getUserMediaStream async{
    final mp = <String, dynamic>{
      'audio': false,
      'video': {
        'facingMode': 'user'
      }
    };
    final stream = await navigator.mediaDevices.getUserMedia(mp);
    _localRenderer.srcObject = stream;
    Future.delayed(const Duration(seconds: 1)).then((value){
      setState(() {

      });
    });
    return stream;
  }

  Future<RTCPeerConnection> _createPeerConnection() async{
    final config = <String, dynamic>{
      "sdpSemantics": "plan-b", //this line is added
      'iceServers': [
        //{ "url": "stun:34.143.165.178:3478" },
        {
          "url": "turn:34.143.165.178:3478?transport=udp",
          "username": "test",
          "credential": "test123",
        }
      ]
    };

    final pc = await createPeerConnection(config);
    await pc.addStream(_localStream);

    pc.onIceCandidate = (e){
      if(e.candidate != null){
        print(e.toMap());
      }
    };
    pc.onAddStream = (stream){
      print('addStream: ${stream.id}');
      ///_remoteRenderer.srcObject = stream;
      ///setState(() {});
    };
    return pc;
  }

  void _initRoom(){
    _roomSubs = _curRoom.snapshots().listen((event) {
      final data = event.data();
      if(data == null) Navigator.pop(context);
    });
  }

  Future<void> _deleteInnerCollection() async{
    final innerCollection = await _curRoom.collection(widget.callEnum == CallEnum.outgoing ? 'offer' : 'answer').get();
    for(var item in innerCollection.docs){
      await item.reference.delete();
    }
  }

  void _deleteRoomAndRecoverState() async{
    await _deleteInnerCollection();
    _curRoom.delete();
    _curUser.update({
      'inAnotherCall': false,
      'incomingCallFrom': null
    });
    _roomSubs?.cancel();
  }

  Future<void> _initPeerConnection() async{
    _peerConnection = await _createPeerConnection();
  }

  Future<void> _setRemoteDescription({required Map<String, dynamic> sdpMap}) async{
    final description = RTCSessionDescription(sdpMap['sdp'], sdpMap['type']);
    return await _peerConnection.setRemoteDescription(description);
  }

  var y = 0;

  var offerOrAnswerIsAlreadyAdded = false;

  void _createOffer() async{
    //final description = await _peerConnection?.createOffer(_cons);
    final offer = await _peerConnection.createOffer();
    await _peerConnection.setLocalDescription(offer);
    _roomInnerCollection = _curRoom.collection('offer');
    _roomInnerCollection?.add(offer.toMap());
    _curRoomSubs = _curRoom.collection('answer').snapshots().listen((snapshot) async{
      if(!offerOrAnswerIsAlreadyAdded){
        print('create offer is called: ${++y} times');
        final data = snapshot.docChanges;
        for(var item in data){
          if(item.type == DocumentChangeType.added){
            final sdpMap = item.doc.data();
            if(sdpMap != null){
              offerOrAnswerIsAlreadyAdded = true;
              await _setRemoteDescription(sdpMap: sdpMap);
            }
          }
        }
      }
    });
  }

  var x = 0;

  void _createAnswer() async{
    _curRoomSubs = _curRoom.collection('offer').snapshots().listen((snapshot) async {
      if(!offerOrAnswerIsAlreadyAdded){
        print('answer offer is called: ${++x} times');
        final data = snapshot.docChanges;
        for(var item in data){
          if(item.type == DocumentChangeType.added){
            final sdpMap = item.doc.data();
            if(sdpMap != null){
              offerOrAnswerIsAlreadyAdded = true;
              await _setRemoteDescription(sdpMap: sdpMap);
              final answer = await _peerConnection.createAnswer();
              await _peerConnection.setLocalDescription(answer);
              _roomInnerCollection = _curRoom.collection('answer');
              _roomInnerCollection?.add(answer.toMap());
            }
          }
        }
      }
    });
  }

  Future<void> _initLocalRendererAndPeer() async{
    await _localRenderer.initialize();
    _localStream = await _getUserMediaStream;
    await _initPeerConnection();
  }

  Future<void> _disposeLocalRenderer() async{
    _localRenderer.dispose();
    _localStream.dispose();
  }

  Future<void> _initRemoteRenderer() async{

  }

  // void _setCandidate() async{
  //   final jsonString = _sdpController.text;
  //   final session = await jsonDecode(jsonString);
  //   print(session['candidate']);
  //   final candidate = RTCIceCandidate(
  //       session['candidate'], session['sdpMid'], session['sdpMLineIndex']);
  //   await _peerConnection?.addCandidate(candidate);
  // }

  void _initRenderers() async{
    await _initLocalRendererAndPeer();
    if(widget.callEnum == CallEnum.outgoing){ _createOffer(); }
    else{ _createAnswer(); }
  }

  void _disposeRenderers(){
    _disposeLocalRenderer();
  }

  void _cancelSubscriptions(){
    _curRoomSubs?.cancel();
  }

  @override
  void dispose() {
    _deleteRoomAndRecoverState();
    _disposeRenderers();
    _cancelSubscriptions();
    super.dispose();
  }

  @override
  void initState() {
    _initRenderers();
    _initRoom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('enum is: ${widget.callEnum}');
    return Scaffold(
      appBar: AppBar(title: const Text('Calling Screen')),
      body: Column(
        children: [
          Flexible(
            child: Container(
              key: const Key('local'),
              margin: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Colors.black),
              child: RTCVideoView(_localRenderer, mirror: true),
            ),
          ),
        ],
      ),
    );
  }
}
