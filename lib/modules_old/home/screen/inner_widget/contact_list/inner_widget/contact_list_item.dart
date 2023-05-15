import 'package:appeler/core/app_common/constants/color_constants.dart';
import 'package:flutter/material.dart';
class ContactListItem extends StatelessWidget {
  const ContactListItem({
    super.key,
    required this.name,
    required this.id,
    required this.isOnline,
    required this.inAnotherCall,
  });

  final String id, name;
  final bool isOnline, inAnotherCall;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ID: $id', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Text('Status: ${isOnline ? 'Online' : 'Offline'}', style: TextStyle(color: isOnline ? kGreenColor : kRedColor, fontWeight: FontWeight.bold))
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name: $name'),
                  Text('Call status: ${inAnotherCall ? 'Busy' : 'Available'}', style: TextStyle(color: inAnotherCall ? kOrangeColor : kPrimaryColor, fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}