import 'package:json_annotation/json_annotation.dart';
import 'package:teacher_mate/src/entity/lesson.dart';

part 'lesson_request.g.dart';

@JsonSerializable()
class LessonRequest {
  final int studentId;
  final int start;
  final int end;
  final int userId;
  final int type;

  LessonRequest({
    required this.studentId,
    required this.start,
    required this.end,
    required this.userId,
    required this.type,
  });

  factory LessonRequest.fromEntity({required LessonEntity lessonEntity}) =>
      LessonRequest(
          studentId: lessonEntity.studentId,
          start: lessonEntity.start,
          end: lessonEntity.end,
          userId: lessonEntity.userId,
          type: lessonEntity.type);

  factory LessonRequest.fromJson(Map<String, dynamic> json) =>
      _$LessonRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LessonRequestToJson(this);
}
