import 'package:flutter/material.dart';

class AlertDialogButton extends StatelessWidget {
  const AlertDialogButton({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: Card(
          elevation: 5,
          child: Container(
            height: 50,
            width: 100,
            alignment: Alignment.center,
            child: Text(title, style: const TextStyle(fontSize: 18,), textAlign: TextAlign.center,),
          ),
        ),
      ),
    );
  }
}