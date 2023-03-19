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
  final docUser = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: docUser.snapshots(),
      builder: (context, snapshot) {
        final curList = snapshot.data?.docs ?? [];
        return ListView.builder(
          itemCount: curList.length,
          itemBuilder: (context, index){
            final curItem = curList[index].data();
            if(curItem['id'] != AuthManagementUseCase.curUser){
              return ContactListItem(
                name: curItem['name'],
                id: curItem['id'],
                status: curItem['isOnline'],
                anotherCall: curItem['inAnotherCall'],
              );
            }
            else{ return Container(); }
          },
        );
      },
    );
  }
}