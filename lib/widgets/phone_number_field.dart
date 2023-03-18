import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneField extends StatefulWidget {
  final PhoneEditingController? controller;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final String hintCode, hintNumber;
  final String? textCode, textNumber;
  final String recommendedCode;
  final String recommendedDigits;
  final String? error;
  final int maxCodes;
  final int maxDigits;
  final bool Function(Number value)? validator;

  const PhoneField({
    Key? key,
    this.controller,
    this.margin,
    this.borderRadius = 12,
    this.hintCode = "Code",
    this.hintNumber = "Number",
    this.textCode,
    this.textNumber,
    this.recommendedCode = "+1234567890",
    this.recommendedDigits = "1234567890",
    this.maxCodes = 4,
    this.maxDigits = 10,
    this.error,
    this.validator,
  }) : super(key: key);

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  late TextEditingController _codeController, _numberController;
  late FocusNode _focusCode, _focusNumber;
  late PhoneEditingController _controller;
  bool isChangedState = false;

  @override
  void initState() {
    _codeController = TextEditingController();
    _numberController = TextEditingController();
    _focusCode = FocusNode();
    _focusNumber = FocusNode();
    _controller = widget.controller ?? PhoneEditingController();
    _controller.setCallback(setState);
    _controller.setControllers(
      codeController: _codeController,
      numberController: _numberController,
    );
    _controller.setFocuses(
      focusCode: _focusCode,
      focusNumber: _focusNumber,
    );
    _controller.setCode(
      widget.textCode ?? _controller.codeController.text,
    );
    _controller.setNumber(
      widget.textNumber ?? _controller.numberController.text,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PhoneField oldWidget) {
    _controller.setCode(widget.textCode ?? _controller.codeController.text);
    _controller.setNumber(
      widget.textNumber ?? _controller.numberController.text,
    );
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _numberController.dispose();
    _focusCode.dispose();
    _focusNumber.dispose();
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
              //controller: _controller.codeController,
              textAlign: TextAlign.end,
              inputFormatters: _controller.formatter(widget.recommendedCode),
              maxLength: widget.maxCodes,
              onChanged: (value) {
                isChangedState = true;
              },
              buildCounter: counter,
              validator: (value) {
                bool valid =
                    widget.validator?.call(_controller.number) ?? false;
                return !valid && isChangedState ? widget.error : null;
              },
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
              controller: _controller.numberController,
              inputFormatters: _controller.formatter(widget.recommendedDigits),
              maxLength: widget.maxDigits,
              buildCounter: counter,
              onChanged: (value) {
                isChangedState = true;
              },
              validator: (value) {
                bool valid =
                    widget.validator?.call(_controller.number) ?? false;
                return !valid && isChangedState ? widget.error : null;
              },
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

  Widget? counter(
    BuildContext context, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  }) {
    return null;
  }
}

class PhoneEditingController {
  late Function(VoidCallback fn) setState;
  late TextEditingController codeController;
  late TextEditingController numberController;
  late FocusNode focusCode;
  late FocusNode focusNumber;
  bool isFocused = false;

  void setCallback(void Function(VoidCallback fn) setState) {
    this.setState = setState;
  }

  void setControllers({
    required TextEditingController codeController,
    required TextEditingController numberController,
  }) {
    this.codeController = codeController;
    this.numberController = numberController;
  }

  void setFocuses({
    required FocusNode focusCode,
    required FocusNode focusNumber,
  }) {
    this.focusCode = focusCode;
    this.focusNumber = focusNumber;
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

  List<TextInputFormatter>? formatter(String? formatters) {
    final digit = formatters ?? "";
    if (digit.isNotEmpty) {
      return [
        FilteringTextInputFormatter.allow(RegExp("[$digit]")),
      ];
    }
    return null;
  }

  void setCode(String? value) {
    codeController.text = value ?? "";
  }

  void setNumber(String? value) {
    numberController.text = value ?? "";
  }

  Number get number {
    return Number(
      codeController.text,
      numberController.text,
    );
  }

  bool get hasFocus => focusCode.hasFocus || focusNumber.hasFocus;
}

class Number {
  late String? _code;
  late String? _number;

  Number(this._code, this._number);

  set code(String value) => _code = value;

  String get code => _code ?? "";

  set digits(String value) => _number = value;

  String get digits => _number ?? "";

  String get numberWithCode => "$code$digits";
}
