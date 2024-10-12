import 'package:flutter/material.dart';
import 'package:tpmobile/const/colors.dart';


class DropDownMenuWidget extends StatefulWidget {
  final String label;
  final Function(String?)? onChanged;
  final String selectedOption;
  final List<String> options;
  const DropDownMenuWidget(
      {super.key,
      required this.label,
      required this.selectedOption,
      required this.options,
      this.onChanged, 
      });

  @override
  State<DropDownMenuWidget> createState() => _DropDownMenuWidgetState();
}

class _DropDownMenuWidgetState extends State<DropDownMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      focusColor: const Color.fromARGB(123, 0, 174, 222),
      dropdownColor: AppColors.backGroundColor,
      decoration: InputDecoration(
        labelText: widget.label,
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
      ),
      value: widget.selectedOption,
      onChanged: widget.onChanged,
      items: widget.options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
