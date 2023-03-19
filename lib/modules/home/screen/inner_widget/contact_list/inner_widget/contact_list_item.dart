import 'package:flutter/material.dart';
import '../../../../../../core/app_constants/app_color.dart';

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