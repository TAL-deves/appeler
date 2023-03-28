import 'dart:async';

import 'package:appeler/core/app_constants/app_color.dart';
import 'package:appeler/core/widgets/app_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../core/widgets/app_snackbar.dart';
import '../../../auth/api/auth_management.dart';

const groupCallingHostScreenRoute = 'groupCallingHostScreenRoute';

class GroupCallingHostScreen extends StatefulWidget {
  const GroupCallingHostScreen({Key? key, required this.curList}) : super(key: key);

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> curList;

  @override
  State<GroupCallingHostScreen> createState() => _GroupCallingHostScreenState();
}

class _GroupCallingHostScreenState extends State<GroupCallingHostScreen> {
  final _users = FirebaseFirestore.instance.collection('users');
  final _chatRooms = FirebaseFirestore.instance.collection('chat-rooms');
  final _subsMap = <String, StreamSubscription>{};
  late final _curUser = _users.doc(AuthManagementUseCase.curUser);

  @override
  void initState() {
    _makeGroupCall();
    super.initState();
  }

  void _commonDisposeWork(){
    _curUser.update({
      'inAnotherCall': false,
      'inGroupCall': false,
    });
    _subsMap.forEach((key, value) {
      _chatRooms.doc(key).delete();
      value.cancel();
    });
  }

  @override
  void dispose() {
    _commonDisposeWork();
    super.dispose();
  }

  void _makeGroupCall(){
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      AppSnackBar.showSuccessSnackBar(message: 'Starting group call, please wait!!');
    });

    final curUser = _users.doc(AuthManagementUseCase.curUser);
    curUser.update({
      'inAnotherCall': true,
      'inGroupCall': true,
    });
    for(var item in widget.curList){
      final curItem = item.data();
      if(curItem['id'] != AuthManagementUseCase.curUser) {
        final name = curItem['name'];
        final id = curItem['id'];
        final isOnline = curItem['isOnline'] as bool;
        final inAnotherCall = curItem['inAnotherCall'] as bool;
        if(!isOnline) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            AppSnackBar.showFailureSnackBar(message: 'User $id is not online!');
          });
        }
        else if(inAnotherCall) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            AppSnackBar.showFailureSnackBar(message: 'User $id in another call');
          });
        }
        else{
          final remoteUser = _users.doc(id);
          remoteUser.update({
            'incomingCallFrom': AuthManagementUseCase.curUser,
            'inAnotherCall': true,
            'inGroupCall': true,
          });
          final roomId = '${AuthManagementUseCase.curUser}+$id';
          final curRoom = _chatRooms.doc(roomId);
          _subsMap[roomId]?.cancel();
          _subsMap[roomId] = curRoom.snapshots().listen((event) {
            final curData = event.data();
            if(curData != null){
              final isAccepted = curData['accepted'];
              if(isAccepted != null){
                if(isAccepted){
                  AppSnackBar.showSuccessSnackBar(message: 'Call Accepted by $id');
                }
                else{
                  curRoom.delete();
                  curUser.update({
                    'inAnotherCall': false,
                    'inGroupCall': false,
                  });
                  AppSnackBar.showFailureSnackBar(message: 'Call rejected by $id');
                }
              }
            }
            else{
              AppSnackBar.showFailureSnackBar(message: 'Call ended by $id');
            }
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Calling Host Screen'),),
      body: Center(
        child: AppCommonButton(
          color: kRedColor,
          title: 'Cancel call',
          onPressed: (){},
        ),
      ),
    );
  }
}
