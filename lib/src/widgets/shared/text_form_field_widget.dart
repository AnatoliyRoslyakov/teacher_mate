import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(1000),
      ],
      // focusNode: focusNode,
      minLines: 5,
      maxLines: 20,
      keyboardType: TextInputType.multiline,
      onChanged: (text) {},
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
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        filled: true,
        fillColor: Colors.black12,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
