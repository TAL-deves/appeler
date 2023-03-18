import 'package:flutter/material.dart';

class PhoneField extends StatefulWidget {
  final PhoneEditingController? controller;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final String hintCode, hintNumber;
  final String? textCode, textNumber;

  const PhoneField({
    Key? key,
    this.controller,
    this.margin,
    this.borderRadius = 12,
    this.hintCode = "Code",
    this.hintNumber = "Number",
    this.textCode,
    this.textNumber,
  }) : super(key: key);

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  late PhoneEditingController _controller;

  @override
  void initState() {
    _controller = widget.controller ?? PhoneEditingController();
    _controller.setCallback(setState);
    _controller.setCode(widget.textCode ?? _controller.code.text);
    _controller.setNumber(widget.textNumber ?? _controller.number.text);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color borderColor = _controller.hasFocus ? primaryColor : Colors.grey;
    double borderSize = _controller.hasFocus ? 2 : 1;
    return Container(
      width: double.infinity,
      margin: widget.margin ?? const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
          border: Border.all(
            width: borderSize,
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius)),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: TextFormField(
              focusNode: _controller.focusCode,
              controller: _controller.code,
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintCode,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 2,
                  height: 30,
                  color: borderColor.withOpacity(0.5),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 50,
            child: TextFormField(
              focusNode: _controller.focusNumber,
              controller: _controller.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintNumber,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PhoneEditingController {
  late Function(VoidCallback fn) setState;
  late TextEditingController code;
  late TextEditingController number;
  late FocusNode focusCode;
  late FocusNode focusNumber;
  bool isFocused = false;

  void setCallback(void Function(VoidCallback fn) setState) {
    this.setState = setState;
  }

  PhoneEditingController() {
    code = TextEditingController();
    number = TextEditingController();
    focusCode = FocusNode();
    focusNumber = FocusNode();
    focusCode.addListener(_handleCodeFocusChange);
    focusNumber.addListener(_handleNumberFocusChange);
  }

  void _handleCodeFocusChange() {
    if (focusCode.hasFocus != isFocused) {
      setState(() {
        isFocused = hasFocus;
      });
    }
  }

  void _handleNumberFocusChange() {
    if (focusNumber.hasFocus != isFocused) {
      setState(() {
        isFocused = hasFocus;
      });
    }
  }

  void setCode(String? code) {
    this.code.text = code ?? "";
  }

  void setNumber(String? number) {
    this.number.text = number ?? "";
  }

  bool get hasFocus => focusCode.hasFocus || focusNumber.hasFocus;

  void dispose() {
    code.dispose();
    number.dispose();
    focusCode.dispose();
    focusNumber.dispose();
  }
}

class Number {
  final String code;
  final String number;

  const Number({
    this.code = "",
    this.number = "",
  });
}
