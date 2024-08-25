import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teacher_mate/src/theme/app_text_style.dart';

class AmountFormFieldWidget extends StatelessWidget {
  final int Function(int text) onChange;
  final String initValue;
  final String hintText;
  final Widget? prefixIcon;
  final Color iconColor;
  const AmountFormFieldWidget({
    super.key,
    required this.onChange,
    this.initValue = '',
    required this.hintText,
    this.prefixIcon,
    this.iconColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: AppTextStyle.b4f15,
      initialValue: initValue,
      inputFormatters: [
        LengthLimitingTextInputFormatter(5),
        FilteringTextInputFormatter.allow(
          RegExp(r'^[0-9]*'),
        ),
      ],
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: (text) {
        onChange.call(int.tryParse(text) ?? 0);
      },
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: prefixIcon,
              )
            : null,
        prefixIconConstraints:
            const BoxConstraints(maxHeight: 40, maxWidth: 40),
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
