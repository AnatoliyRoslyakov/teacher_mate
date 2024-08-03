import 'package:json_annotation/json_annotation.dart';

part 'lesson_delete_request.g.dart';

@JsonSerializable()
class LessonDeleteRequest {
  final int id;

  LessonDeleteRequest({
    required this.id,
  });

  Map<String, dynamic> toJson() => _$LessonDeleteRequestToJson(this);
}
