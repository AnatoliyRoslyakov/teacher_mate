// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'student_bloc.dart';

class StudentState {
  final List<StudentEntity> studentEntity;
  final bool isLoading;
  const StudentState({
    required this.studentEntity,
    required this.isLoading,
  });
  factory StudentState.initial() =>
      const StudentState(studentEntity: [], isLoading: false);

  StudentState copyWith({
    List<StudentEntity>? studentEntity,
    bool? isLoading,
  }) {
    return StudentState(
      studentEntity: studentEntity ?? this.studentEntity,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
