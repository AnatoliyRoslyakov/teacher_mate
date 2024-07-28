import 'package:json_annotation/json_annotation.dart';

part 'lesson_request.g.dart';

@JsonSerializable()
class LessonRequest {
  final int id;
  final int studentId;
  final int start;
  final int end;
  final int type;
  final String description;

  LessonRequest({
    this.id = 0,
    required this.description,
    required this.studentId,
    required this.start,
    required this.end,
    required this.type,
  });

  factory LessonRequest.fromJson(Map<String, dynamic> json) =>
      _$LessonRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LessonRequestToJson(this);
}
