import 'package:flutter/material.dart';
import 'package:tpmobile/const/colors.dart';
import 'package:tpmobile/const/text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldWidget extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final String? errorText;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const TextFieldWidget({
    Key? key,
    required this.hintText,
    required this.isPassword,
    required this.controller,
    this.errorText,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
            filled: true,
            fillColor: AppColors.fieldsColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            hintText: widget.hintText,
            hintStyle: AppTextStyle.infoText,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            errorText: widget.errorText,
            errorStyle: AppTextStyle.infoText.copyWith(
              color: Colors.red,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}
