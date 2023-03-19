import 'package:appeler/core/widgets/app_alert_dialog.dart';
import 'package:appeler/core/widgets/app_tab_controller.dart';
import 'package:appeler/modules/auth/api/auth_management.dart';
import 'package:flutter/material.dart';
import 'inner_widget/contact_list/contact_outer_item.dart';

const homeScreenRoute = 'kHomeScreen';

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({super.key});

  @override
  State<AppHomeScreen> createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> with WidgetsBindingObserver{

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
    super.initState();
  }

  @override
  void dispose() {
    AuthManagementUseCase.updateOnlineStatus(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          GestureDetector(
            onTap: (){ AppAlertDialog.logoutAlertDialog(context: context); },
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
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
