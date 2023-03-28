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
import '../../../../../group_calling/screen/for_host/group_calling_host_screen.dart';
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
                    return ContactListItem(
                      name: name,
                      id: id,
                      isOnline: isOnline,
                      inAnotherCall: inAnotherCall,
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
                Navigator.of(context).pushNamed(groupCallingHostScreenRoute, arguments: curList);
              },
            ),
          ],
        );
      },
    );
  }
}
