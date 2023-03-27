import 'dart:async';

import 'package:appeler/core/app_constants/app_color.dart';
import 'package:appeler/core/widgets/app_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../core/widgets/app_snackbar.dart';
import '../../auth/api/auth_management.dart';

const groupCallingScreenRoute = 'groupCallingScreenRoute';

class GroupCallingScreen extends StatefulWidget {
  const GroupCallingScreen({Key? key, required this.curList}) : super(key: key);

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> curList;

  @override
  State<GroupCallingScreen> createState() => _GroupCallingScreenState();
}

class _GroupCallingScreenState extends State<GroupCallingScreen> {
  final users = FirebaseFirestore.instance.collection('users');
  final chatRooms = FirebaseFirestore.instance.collection('chat-rooms');
  final subsMap = <String, StreamSubscription>{};

  @override
  void initState() {
    _makeGroupCall();
    super.initState();
  }

  @override
  void dispose() {
    subsMap.forEach((key, value) { value.cancel(); });
    super.dispose();
  }

  void _makeGroupCall(){
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      AppSnackBar.showSuccessSnackBar(message: 'Starting group call, please wait!!');
    });

    final curUser = users.doc(AuthManagementUseCase.curUser);
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
          final remoteUser = users.doc(id);
          remoteUser.update({
            'incomingCallFrom': AuthManagementUseCase.curUser,
            'inAnotherCall': true,
            'inGroupCall': true,
          });
          final curRoom = chatRooms.doc('${AuthManagementUseCase.curUser}+$id');
          subsMap[id]?.cancel();
          subsMap[id] = curRoom.snapshots().listen((event) {
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
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Calling'),),
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
