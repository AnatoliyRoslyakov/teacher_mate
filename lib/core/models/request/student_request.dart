import 'package:json_annotation/json_annotation.dart';

part 'student_request.g.dart';

@JsonSerializable()
class StudentRequest {
  final String name;
  final int price;

  StudentRequest({
    required this.name,
    required this.price,
  });

  factory StudentRequest.fromJson(Map<String, dynamic> json) =>
      _$StudentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StudentRequestToJson(this);
}
