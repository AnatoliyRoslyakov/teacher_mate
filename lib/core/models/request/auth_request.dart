import 'package:json_annotation/json_annotation.dart';

part 'auth_request.g.dart';

@JsonSerializable()
class AuthRequest {
  final String code;
  AuthRequest({
    required this.code,
  });

  Map<String, dynamic> toJson() => _$AuthRequestToJson(this);
}
