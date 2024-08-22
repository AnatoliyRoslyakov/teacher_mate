import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teacher_mate/src/theme/app_text_style.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String Function(String text) onChange;
  final String initValue;
  final (int minLines, int maxLines) lines;
  final int maxSym;
  final String hintText;
  final IconData? prefixIcon;
  final TextAlign textAlign;
  const TextFormFieldWidget({
    super.key,
    required this.onChange,
    this.initValue = '',
    this.lines = (1, 1),
    this.maxSym = 1000,
    required this.hintText,
    this.prefixIcon,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: AppTextStyle.b4f15,
      textAlign: textAlign,
      initialValue: initValue,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxSym),
      ],
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      minLines: lines.$1,
      maxLines: lines.$2,
      keyboardType: TextInputType.multiline,
      onChanged: (text) {
        onChange.call(text);
      },
      decoration: InputDecoration(
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, color: Colors.grey) : null,
        hintText: hintText,
        hintStyle: AppTextStyle.b4f15.copyWith(color: Colors.grey),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        filled: true,
        fillColor: const Color.fromARGB(16, 0, 0, 0),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
