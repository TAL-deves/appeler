import 'package:appeler/core/app_constants/app_color.dart';
import 'package:appeler/core/widgets/app_alert_dialog.dart';
import 'package:appeler/core/widgets/app_tab_controller.dart';
import 'package:flutter/material.dart';

const homeScreenRoute = 'kHomeScreen';

class AppHomeScreen extends StatelessWidget {
  const AppHomeScreen({super.key});

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

class ContactListOuterItem extends StatelessWidget {
  const ContactListOuterItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index){
        return ContactListItem(
          name: 'Shimul',
          id: '1111',
          status: index % 2 == 0,
          anotherCall: index % 3 == 0,
        );
      },
    );
  }
}

class ContactListItem extends StatelessWidget {
  const ContactListItem({
    super.key,
    required this.name,
    required this.id,
    required this.status,
    required this.anotherCall,
  });

  final String id, name;
  final bool status, anotherCall;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ID: $id', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Text('Status: ${status ? 'Online' : 'Offline'}', style: TextStyle(color: status ? kGreenColor : kRedColor, fontWeight: FontWeight.bold))
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Name: $name'),
                Text('Call status: ${anotherCall ? 'Busy' : 'Available'}', style: TextStyle(color: anotherCall ? kOrangeColor : kPrimaryColor, fontWeight: FontWeight.bold))
              ],
            )
          ],
        ),
      ),
    );
  }
}
