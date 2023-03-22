import 'package:flutter/material.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/otp_field.dart';
import '../../../core/widgets/text_view.dart';

class AuthOtpBody extends StatefulWidget {
  final Function(String otp)? onOtpCallback;

  const AuthOtpBody({
    Key? key,
    this.onOtpCallback,
  }) : super(key: key);

  @override
  State<AuthOtpBody> createState() => _AuthOtpBodyState();
}

class _AuthOtpBodyState extends State<AuthOtpBody> {
  late OtpEditingController otp;

  @override
  void initState() {
    otp = OtpEditingController();
    super.initState();
  }

  @override
  void dispose() {
    otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      child: Column(
        children: [
          const TextView(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            text: "Phone Verification",
            textAlign: TextAlign.center,
            textColor: Colors.black,
            textStyle: FontWeight.bold,
            textSize: 24,
          ),
          const TextView(
            padding: EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 32),
            text: "Enter your OTP code here",
            textAlign: TextAlign.center,
            textColor: Colors.grey,
            textSize: 14,
          ),
          OtpField(
            controller: otp,
            width: 200,
          ),
          Button(
            text: "Submit",
            width: 200,
            borderRadius: 12,
            onPressed: () => widget.onOtpCallback?.call(otp.text),
          ),
        ],
      ),
    );
  }
}