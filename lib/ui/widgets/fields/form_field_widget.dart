import 'package:flutter/material.dart';
import 'package:tpmobile/const/colors.dart';


class CustomFormField extends StatelessWidget {
  final void Function(String)? onchanged;
  final String hintText;
  final String labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final IconData? suffixIcon;
  final bool? isMultiLine;

  const CustomFormField({
    Key? key,
    required this.hintText,
    required this.labelText,
    this.controller,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.onchanged, this.isMultiLine = false,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: isMultiLine! ? 3 : 1,
      onChanged: onchanged,
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      textInputAction: TextInputAction.next, 
      onTap: onTap,
      cursorColor: AppColors.primaryColor,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFECECEC),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 2,
          ),
        ),
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      ),
    );
  }
}
