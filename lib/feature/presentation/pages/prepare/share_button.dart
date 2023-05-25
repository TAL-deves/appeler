import 'package:flutter/material.dart';

class ShareScreenButtonForPrepareBody extends StatelessWidget {
  const ShareScreenButtonForPrepareBody({super.key, required this.onPressed, required this.isEnabled});

  final Function() onPressed;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AbsorbPointer(
        child: Container(
          margin: const EdgeInsets.only(
            top: 16,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(6),
            color: isEnabled ? Colors.green.withOpacity(0.5) : null,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.present_to_all,
                size: 20,
                color: Colors.blue,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Share screen",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
