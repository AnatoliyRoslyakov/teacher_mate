import 'package:json_annotation/json_annotation.dart';

part 'student_response.g.dart';

@JsonSerializable()
class StudentResponse {
  final int id;
  final String name;
  final int price;

  StudentResponse({
    required this.id,
    required this.name,
    required this.price,
  });

  factory StudentResponse.fromJson(Map<String, dynamic> json) =>
      _$StudentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StudentResponseToJson(this);
}
