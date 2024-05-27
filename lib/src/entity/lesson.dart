import 'package:teacher_mate/core/models/response/lesson_response.dart';

class LessonEntity {
  final int studentId;
  final int start;
  final int end;
  final int userId;
  final int type;

  LessonEntity({
    required this.studentId,
    required this.start,
    required this.end,
    required this.userId,
    required this.type,
  });

  factory LessonEntity.isEmpty() =>
      LessonEntity(studentId: 0, start: 0, end: 0, userId: 0, type: 0);

  factory LessonEntity.fromEntity({required LessonResponse lessonResponse}) =>
      LessonEntity(
          studentId: lessonResponse.studentId,
          start: lessonResponse.start,
          end: lessonResponse.end,
          userId: lessonResponse.userId,
          type: lessonResponse.type);
}
