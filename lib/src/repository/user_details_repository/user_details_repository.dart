import 'package:teacher_mate/core/api/api_handler.dart';
import 'package:teacher_mate/core/models/response/user_details_response.dart';

abstract class IUserDetailsRepository {
  Future<UserDetailsResponse> getUserDetails();
}

class UserDetailsRepository implements IUserDetailsRepository {
  final ApiHandler apiHandler;

  UserDetailsRepository(this.apiHandler);
  @override
  Future<UserDetailsResponse> getUserDetails() async {
    return await apiHandler.getUserDetails();
  }
}
