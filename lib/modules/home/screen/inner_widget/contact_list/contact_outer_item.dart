import 'dart:async';

import 'package:appeler/core/widgets/app_snackbar.dart';
import 'package:appeler/modules/calling/screen/calling_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../auth/api/auth_management.dart';
import 'inner_widget/contact_list_item.dart';

class ContactListOuterItem extends StatefulWidget {
  const ContactListOuterItem({super.key});

  @override
  State<ContactListOuterItem> createState() => _ContactListOuterItemState();
}

class _ContactListOuterItemState extends State<ContactListOuterItem> {
  final users = FirebaseFirestore.instance.collection('users');
  final chatRooms = FirebaseFirestore.instance.collection('chat-rooms');
  var x = 1;
  StreamSubscription? subscription;

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
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
                    AppSnackBar.showSuccessSnackBar(message: 'Calling....Please wait!');
                    final remoteUser = users.doc(id);
                    final curUser = users.doc(AuthManagementUseCase.curUser);
                    curUser.update({
                      'inAnotherCall': true,
                    });
                    remoteUser.update({
                      'incomingCallFrom': AuthManagementUseCase.curUser,
                      'inAnotherCall': true
                    });
                    final curRoom = chatRooms.doc('${AuthManagementUseCase.curUser}+$id');
                    subscription?.cancel();
                    subscription = curRoom.snapshots().listen((event) {
                      final curData = event.data();
                      print('outer listener is called: ${x++} times and data is :$curData');
                      if(curData != null){
                        final isAccepted = curData['accepted'];
                        if(isAccepted){
                          Navigator.of(context).pushNamed(callingScreenRoute, arguments: id);
                        }
                        else{
                          curRoom.delete();
                          curUser.update({
                            'inAnotherCall': false,
                          });
                          AppSnackBar.showFailureSnackBar(message: 'Call rejected');
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