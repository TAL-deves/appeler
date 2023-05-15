import 'package:appeler/new_modules/new_home/join_group/join_group_screen.dart';
import 'package:flutter/material.dart';
import '../../core/app_common/api/use_case/auth_management.dart';
import '../../widgets/app_alert_dialog.dart';
import '../../widgets/app_tab_controller.dart';
import 'create_group/create_group_screen.dart';

class NewHomeScreen extends StatelessWidget {
  const NewHomeScreen({Key? key}) : super(key: key);

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
      body: const AppTabController(
        tabItemTitles: ['CREATE GROUP', 'JOIN GROUP'],
        tabChildren: [
          CreateGroupScreen(),
          JoinGroupScreen(),
        ],
      ),
    );
  }
}






