import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_mate/src/bloc/student_bloc/student_bloc.dart';
import 'package:teacher_mate/src/pages/web/create_student_dialog.dart';
import 'package:teacher_mate/core/router/app_router.dart';
import 'package:teacher_mate/src/theme/app_colors.dart';
import 'package:teacher_mate/src/theme/app_text_style.dart';
import 'package:teacher_mate/src/theme/resource/svgs.dart';

class StudentListWidget extends StatefulWidget {
  final bool mobile;
  final int studentId;
  final double? height;
  final double? width;
  final Function(int id)? selectStudent;
  final bool toggle;
  const StudentListWidget({
    super.key,
    this.mobile = false,
    this.selectStudent,
    this.height,
    this.width,
    this.studentId = -1,
    this.toggle = false,
  });

  @override
  State<StudentListWidget> createState() => _StudentListWidgetState();
}

class _StudentListWidgetState extends State<StudentListWidget> {
  late int studentId;
  @override
  void initState() {
    studentId = widget.studentId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<StudentBloc, StudentState>(
                builder: (context, stateStudent) {
              return stateStudent.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: stateStudent.studentEntity.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'The list is empty, add a student',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: SvgPicture.asset(Svgs.addStudents),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 10,
                              ),
                              itemCount: stateStudent.studentEntity.length,
                              itemBuilder: (context, i) {
                                return widget.selectStudent != null
                                    ? InkWell(
                                        hoverColor: AppColors.mainColor,
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () {
                                          widget.selectStudent?.call(
                                              stateStudent.studentEntity[i].id);
                                          setState(() {
                                            studentId = stateStudent
                                                .studentEntity[i].id;
                                          });
                                        },
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              gradient: LinearGradient(colors: [
                                                AppColors.mainColor,
                                                AppColors.mainColor
                                                    .withOpacity(0.5)
                                              ]),
                                              color: studentId ==
                                                      stateStudent
                                                          .studentEntity[i].id
                                                  ? AppColors.mainColor
                                                  : Colors.grey
                                                      .withOpacity(0.2)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        Svgs.user,
                                                        color: studentId ==
                                                                stateStudent
                                                                    .studentEntity[
                                                                        i]
                                                                    .id
                                                            ? Colors.white
                                                            : AppColors
                                                                .mainColor,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        stateStudent
                                                            .studentEntity[i]
                                                            .name,
                                                        style:
                                                            AppTextStyle.b4f14,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          widget.mobile
                                              ? context.push(
                                                  MobileRoutes
                                                      .createStudent.path,
                                                  extra: {
                                                      'edit': true,
                                                      'id': stateStudent
                                                          .studentEntity[i].id,
                                                      'name': stateStudent
                                                          .studentEntity[i]
                                                          .name,
                                                      'price': stateStudent
                                                          .studentEntity[i]
                                                          .price,
                                                      'tgName': stateStudent
                                                          .studentEntity[i]
                                                          .tgName
                                                    })
                                              : createStudentDialog(
                                                  context: context,
                                                  edit: true,
                                                  id: stateStudent
                                                      .studentEntity[i].id,
                                                  name: stateStudent
                                                      .studentEntity[i].name,
                                                  price: stateStudent
                                                      .studentEntity[i].price,
                                                  tgName: stateStudent
                                                      .studentEntity[i].tgName);
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              gradient: LinearGradient(colors: [
                                                AppColors.mainColor,
                                                AppColors.mainColor
                                                    .withOpacity(0.7)
                                              ]),
                                              color: AppColors.mainColor),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        Svgs.user,
                                                        color: Colors.white,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        stateStudent
                                                            .studentEntity[i]
                                                            .name,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            AppTextStyle.b4f14,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                              },
                            ),
                    );
            }),
          ),
          InkWell(
              onTap: () {
                widget.mobile
                    ? context.push(MobileRoutes.createStudent.path, extra: {
                        'edit': false,
                        'id': 0,
                        'name': '',
                        'price': 0,
                        'tgName': ''
                      })
                    : createStudentDialog(
                        context: context,
                        nested: !widget.toggle,
                      );
              },
              child: Container(
                  height: widget.selectStudent == null ? 50 : 40,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      color: Colors.grey.withOpacity(0.3)),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: SvgPicture.asset(Svgs.plus,
                              color: Colors.grey))))),
        ],
      ),
    );
  }
}
