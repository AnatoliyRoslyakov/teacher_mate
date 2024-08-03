import 'package:json_annotation/json_annotation.dart';

part 'student_delete_request.g.dart';

@JsonSerializable()
class StudentDeleteRequest {
  final int id;

  StudentDeleteRequest({
    required this.id,
  });

  Map<String, dynamic> toJson() => _$StudentDeleteRequestToJson(this);
}
