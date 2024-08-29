import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teacher_mate/src/bloc/student_bloc/student_bloc.dart';
import 'package:teacher_mate/src/theme/resource/svgs.dart';
import 'package:teacher_mate/src/util/url_util.dart';
import 'package:teacher_mate/src/widgets/shared/amount_form_field.dart';
import 'package:teacher_mate/src/widgets/shared/app_button.dart';
import 'package:teacher_mate/src/widgets/shared/divider_title_widget.dart';
import 'package:teacher_mate/src/widgets/shared/text_form_field_widget.dart';

class CreateStudentWidget extends StatefulWidget {
  final int id;
  final String name;
  final bool edit;
  final int price;
  final String tgName;

  const CreateStudentWidget(
      {super.key,
      required this.id,
      required this.name,
      required this.edit,
      required this.price,
      required this.tgName});

  @override
  State<CreateStudentWidget> createState() => _CreateStudentWidgetState();
}

class _CreateStudentWidgetState extends State<CreateStudentWidget> {
  bool isValid = true;
  late String name;
  late int price;
  late bool edit;
  late int id;
  late String tgName;

  @override
  void initState() {
    name = widget.name;
    price = widget.price;
    edit = widget.edit;
    id = widget.id;
    tgName = widget.tgName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isValid = name.isNotEmpty && price >= 0;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(children: [
              const DividerTitleWidget(title: 'Student'),
              TextFormFieldWidget(
                prefixIcon: SvgPicture.asset(
                  Svgs.user,
                  color: Colors.grey,
                ),
                hintText: 'Student name',
                maxSym: 15,
                lines: (1, 1),
                initValue: name,
                onChange: (value) {
                  setState(() {
                    name = value;
                  });
                  return name;
                },
              ),
              const DividerTitleWidget(title: 'Telegram'),
              Row(
                children: [
                  Expanded(
                    child: TextFormFieldWidget(
                      prefixIcon: SvgPicture.asset(
                        Svgs.telegram2,
                        color: Colors.grey,
                      ),
                      hintText: '@MyStudent',
                      maxSym: 15,
                      lines: (1, 1),
                      initValue: tgName,
                      onChange: (value) {
                        setState(() {
                          tgName = value;
                        });
                        return tgName;
                      },
                    ),
                  ),
                  AppButton.icon(
                      backgroundColor: Colors.transparent,
                      icon: SvgPicture.asset(
                        Svgs.telegram,
                      ),
                      onTap: () {
                        UrlUtils.openStudent(tgName);
                      })
                ],
              ),
              const DividerTitleWidget(title: 'Price'),
              AmountFormFieldWidget(
                  initValue: price == 0 ? '' : price.toString(),
                  prefixIcon: SvgPicture.asset(
                    Svgs.dollar,
                    color: Colors.grey,
                  ),
                  onChange: (value) {
                    setState(() {
                      price = value;
                    });
                    return price;
                  },
                  hintText: 'Lesson price')
            ]),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                // flex: 3,
                child: AppButton.base(
                  label: widget.edit ? 'Edit' : 'Save',
                  onTap: isValid
                      ? () {
                          widget.edit
                              ? context.read<StudentBloc>().add(
                                  StudentEvent.update(id, name, price, tgName))
                              : context.read<StudentBloc>().add(
                                  StudentEvent.create(name, price, tgName));
                          Navigator.of(context).pop();
                        }
                      : null,
                ),
              ),
              widget.edit
                  ? const SizedBox(
                      width: 10,
                    )
                  : const SizedBox.shrink(),
              widget.edit
                  ? AppButton.icon(
                      backgroundColor: Colors.transparent,
                      icon: SvgPicture.asset(
                        Svgs.trash,
                        color: Colors.red,
                      ),
                      onTap: () {
                        context
                            .read<StudentBloc>()
                            .add(StudentEvent.delete(id));
                        Navigator.of(context).pop();
                      },
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
