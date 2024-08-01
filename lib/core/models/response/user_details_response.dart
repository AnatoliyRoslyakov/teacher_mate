import 'package:json_annotation/json_annotation.dart';

part 'user_details_response.g.dart';

@JsonSerializable()
class UserDetailsResponse {
  final String username;
  final String name;
  UserDetailsResponse({
    required this.username,
    required this.name,
  });

  factory UserDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsResponseFromJson(json);
}
