import 'dart:async';
import 'package:appeler/core/app_constants/app_color.dart';
import 'package:appeler/core/widgets/app_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/widgets/app_alert_dialog.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../../../../../auth/api/auth_management.dart';
import '../../../../../calling/screen/call_enum/call_enum.dart';
import '../../../../../calling/screen/calling_screen.dart';
import '../../../../../group_calling/screen/group_calling_screen.dart';
import '../../contact_list/inner_widget/contact_list_item.dart';

class GroupContactListScreen extends StatefulWidget {
  const GroupContactListScreen({Key? key}) : super(key: key);

  @override
  State<GroupContactListScreen> createState() => _GroupContactListScreenState();
}

class _GroupContactListScreenState extends State<GroupContactListScreen> {
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
        return Column(
          children: [
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
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
                          AppSnackBar.showSuccessSnackBar(message: 'Starting group call....Please wait!');
                          final curUser = users.doc(AuthManagementUseCase.curUser);
                          final remoteUser = users.doc(id);

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
              ),
            ),
            const SizedBox(height: 10,),
            AppCommonButton(
              title: 'Group call',
              color: kPrimaryColor,
              onPressed: (){
                //_makeGroupCall(curList);
                Navigator.of(context).pushNamed(groupCallingScreenRoute, arguments: curList);
              },
            ),
          ],
        );
      },
    );
  }
}
