import 'dart:async';

import 'package:appeler/core/widgets/app_alert_dialog.dart';
import 'package:appeler/core/widgets/app_tab_controller.dart';
import 'package:appeler/modules/auth/api/auth_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'inner_widget/contact_list/contact_outer_item.dart';

const homeScreenRoute = 'kHomeScreen';

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({super.key});

  @override
  State<AppHomeScreen> createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> with WidgetsBindingObserver{
  StreamSubscription? subscription;
  var c = 1;

  void _listenForIncomingCall(){
    final users = FirebaseFirestore.instance.collection('users');
    final chatRooms = FirebaseFirestore.instance.collection('chat-rooms');
    final curUser = users.doc(AuthManagementUseCase.curUser);
    subscription = curUser.snapshots().listen((event) async {
      print('calling from listen ${c++} times');
      final data = event.data();
      if(data != null){
        final inComingCallFrom = data['incomingCallFrom'];
        if(inComingCallFrom != null){
          final result = await AppAlertDialog.callingDialog(context: context, callerId: inComingCallFrom);
          final curRoom = chatRooms.doc('$inComingCallFrom+${AuthManagementUseCase.curUser}');
          curRoom.set({
            'accepted': result
          });
          if(!result){
            curUser.update({
              'incomingCallFrom': null,
              'inAnotherCall': false,
            });
          }
        }
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){ AuthManagementUseCase.updateOnlineStatus(true); }
    else{ AuthManagementUseCase.updateOnlineStatus(false); }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    AuthManagementUseCase.updateOnlineStatus(true);
    _listenForIncomingCall();
    super.initState();
  }

  @override
  void dispose() {
    AuthManagementUseCase.updateOnlineStatus(false);
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          Text('User ID: ${AuthManagementUseCase.curUser}'),
          GestureDetector(
            onTap: (){ AppAlertDialog.logoutAlertDialog(context: context); },
            child: const Padding(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: Icon(Icons.logout),
            ),
          )
        ],
      ),
      body: AppTabController(
        tabItemTitles: const ['Contacts', 'Call', 'Group'],
        tabChildren: [
          const ContactListOuterItem(),
          Text(2.toString()),
          Text(3.toString())
        ],
      ),
    );
  }
}
