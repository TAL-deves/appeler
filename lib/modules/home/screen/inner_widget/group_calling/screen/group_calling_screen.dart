import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/app_alert_dialog.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../auth/api/auth_management.dart';
import '../../../../../calling/screen/call_enum/call_enum.dart';
import '../../../../../calling/screen/calling_screen.dart';
import '../../contact_list/inner_widget/contact_list_item.dart';

class GroupCallingScreen extends StatefulWidget {
  const GroupCallingScreen({Key? key}) : super(key: key);

  @override
  State<GroupCallingScreen> createState() => _GroupCallingScreenState();
}

class _GroupCallingScreenState extends State<GroupCallingScreen> {
  final users = FirebaseFirestore.instance.collection('users');
  final chatRooms = FirebaseFirestore.instance.collection('chat-rooms');
  StreamSubscription? subscription;

  void _closeOutgoingDialog(){
    if(AppAlertDialog.outgoingDialogIsOpen){
      Navigator.pop(context);
      AppAlertDialog.outgoingDialogIsOpen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: users.snapshots(),
      builder: (context, snapshot) {
        final curList = snapshot.data?.docs ?? [];
        return ListView.builder(
          itemCount: curList.length,
          itemBuilder: (context, index){
            final curItem = curList[index].data();
            if(curItem['id'] != AuthManagementUseCase.curUser){
              final name = curItem['name'];
              final id = curItem['id'];
              final isOnline = curItem['isOnline'] as bool;
              final inAnotherCall = curItem['inAnotherCall'] as bool;
              return GestureDetector(
                onTap: (){
                  if(!isOnline) { AppSnackBar.showFailureSnackBar(message: 'User is not online!'); }
                  else if(inAnotherCall) { AppSnackBar.showFailureSnackBar(message: 'User in another call'); }
                  else{
                    //AppSnackBar.showSuccessSnackBar(message: 'Calling....Please wait!');
                    final remoteUser = users.doc(id);
                    final curUser = users.doc(AuthManagementUseCase.curUser);
                    AppAlertDialog.outGoingCallDialog(context: context, callerId: id).then((value){
                      if(value != null && value){
                        remoteUser.update({
                          'incomingCallFrom': null,
                          'inAnotherCall': false,
                          'inGroupCall': false,
                        });
                        curUser.update({
                          'inAnotherCall': false,
                          'inGroupCall': false,
                        });
                      }
                    });
                    curUser.update({
                      'inAnotherCall': true,
                      'inGroupCall': true,
                    });
                    remoteUser.update({
                      'incomingCallFrom': AuthManagementUseCase.curUser,
                      'inAnotherCall': true,
                      'inGroupCall': true,
                    });
                    final curRoom = chatRooms.doc('${AuthManagementUseCase.curUser}+$id');
                    subscription?.cancel();
                    subscription = curRoom.snapshots().listen((event) {
                      final curData = event.data();
                      if(curData != null){
                        final isAccepted = curData['accepted'];
                        if(isAccepted != null){
                          if(isAccepted){
                            _closeOutgoingDialog();
                            Navigator.of(context).pushNamed(callingScreenRoute, arguments: [id, CallEnum.outgoing]);
                          }
                          else{
                            curRoom.delete();
                            curUser.update({
                              'inAnotherCall': false,
                              'inGroupCall': false,
                            });
                            AppSnackBar.showFailureSnackBar(message: 'Call rejected');
                            _closeOutgoingDialog();
                          }
                        }
                      }
                    });
                  }
                },
                child: ContactListItem(
                  name: name,
                  id: id,
                  isOnline: isOnline,
                  inAnotherCall: inAnotherCall,
                ),
              );
            }
            else{ return Container(); }
          },
        );
      },
    );
  }
}
