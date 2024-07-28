import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_mate/src/bloc/student_bloc/student_bloc.dart';

class StudentListWidget extends StatefulWidget {
  final bool mobile;
  final int studentId;
  final double? height;
  final double? width;
  final Function(int id)? selectStudent;
  const StudentListWidget({
    super.key,
    this.mobile = false,
    this.selectStudent,
    this.height,
    this.width,
    this.studentId = -1,
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
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'The list is empty, add a student',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Icon(
                                    Icons.touch_app,
                                    size: 100,
                                    color: Colors.black12,
                                  ),
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
                                        hoverColor: Colors.amber,
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
                                              color: studentId ==
                                                      stateStudent
                                                          .studentEntity[i].id
                                                  ? Colors.amber
                                                  : Colors.black12),
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
                                                      const Icon(
                                                        Icons.person,
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
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Expanded(
                                                //   child: Align(
                                                //     alignment:
                                                //         Alignment.centerRight,
                                                //     child: Text(
                                                //       'price: ${stateStudent.studentEntity[i].price}р',
                                                //       overflow:
                                                //           TextOverflow.ellipsis,
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onLongPress: () {
                                          showBlurredDialog(context);
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.amber),
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
                                                      const Icon(
                                                        Icons.person,
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
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Expanded(
                                                //   child: Align(
                                                //     alignment:
                                                //         Alignment.centerRight,
                                                //     child: Text(
                                                //       'price: ${stateStudent.studentEntity[i].price}р',
                                                //       overflow:
                                                //           TextOverflow.ellipsis,
                                                //     ),
                                                //   ),
                                                // ),
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
                showBlurredDialog(context);
              },
              child: Container(
                  height: widget.selectStudent == null ? 50 : 40,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      color: Color.fromARGB(255, 233, 233, 233)),
                  child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Icon(Icons.add))))),
        ],
      ),
    );
  }
}

void showBlurredDialog(
  BuildContext context,
) {
  bool isValid = true;
  String name = '';
  int price = 0;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          isValid = name.isNotEmpty && price >= 0;
          return Dialog(
            insetAnimationCurve: Curves.linear,
            insetAnimationDuration: const Duration(milliseconds: 500),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Student', style: TextStyle(fontSize: 24)),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter a name',
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Lesson amount',
                          style: TextStyle(fontSize: 24)),
                      const SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            price = int.tryParse(value) ?? 0;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter the amount',
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (isValid) {
                            context
                                .read<StudentBloc>()
                                .add(StudentEvent.create(name, price));
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          'Сохранить',
                          style: TextStyle(
                              color: isValid ? Colors.deepPurple : Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
