import 'package:flutter/material.dart';
import 'package:tpmobile/const/colors.dart';
import 'package:tpmobile/const/text.dart';

class ButtonWidget extends StatefulWidget {
  final String buttonText;
  final VoidCallback? onClick;
  final TextStyle? textStyle;
  final double? padding;
  const ButtonWidget(
      {super.key,
      required this.buttonText,
      required this.onClick,
      this.textStyle,
      this.padding});

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onClick,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        padding: EdgeInsets.symmetric(vertical: widget.padding ?? 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        widget.buttonText,
        style: widget.textStyle ?? AppTextStyle.buttonText,
      ),
    );
  }
}
