import 'package:json_annotation/json_annotation.dart';

part 'lesson_response.g.dart';

@JsonSerializable()
class LessonResponse {
  final int studentId;
  final int start;
  final int end;
  final int userId;
  final int type;
  final int id;
  final String description;

  LessonResponse({
    required this.id,
    required this.description,
    required this.studentId,
    required this.start,
    required this.end,
    required this.userId,
    required this.type,
  });

  factory LessonResponse.fromJson(Map<String, dynamic> json) =>
      _$LessonResponseFromJson(json);
}
