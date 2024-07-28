import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String Function(String text) onChange;
  final String description;
  const TextFormFieldWidget({
    super.key,
    required this.onChange,
    this.description = '',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: description,
      inputFormatters: [
        LengthLimitingTextInputFormatter(1000),
      ],
      // focusNode: focusNode,
      minLines: 5,
      maxLines: 20,
      keyboardType: TextInputType.multiline,
      onChanged: (text) {
        onChange.call(text);
      },
      // controller: controller,
      // style: context.customText.bodyDescriptionMedium.copyWith(
      //   color: context.customColor.black,
      //   fontSize: 15,
      // ),
      decoration: InputDecoration(
        // suffixIcon: InkWell(
        //   onTap: () {
        //     // setState(() {
        //     //   controller.clear();
        //     // });
        //     // context
        //     //     .read<AppealBloc>()
        //     //     .add(const AppealEvent.message(''));
        //     // focusNode.unfocus();
        //   },
        //   child: Icon(Icons.close),
        // ),
        hintText: 'Lesson plan',
        hintStyle: const TextStyle(fontWeight: FontWeight.w400),
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
