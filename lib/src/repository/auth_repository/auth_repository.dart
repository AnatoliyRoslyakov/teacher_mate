import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_mate/core/api/api_handler.dart';
import 'package:teacher_mate/core/models/request/auth_request.dart';

abstract class IAuthRepository {
  Future<String> checkAuth();

  Future<String> login({required String code});

  Future<void> logout();
}

const tokenKey = 'tokenKey';

class AuthRepositoryImpl implements IAuthRepository {
  final ApiHandler apiHandler;
  final SharedPreferences preferences;

  AuthRepositoryImpl(this.apiHandler, this.preferences);

  @override
  Future<String> login({required String code}) async {
    final token = await apiHandler.login(AuthRequest(code: code));
    await preferences.setString(tokenKey, token);
    return token;
  }

  @override
  Future<String> checkAuth() async {
    return preferences.getString(tokenKey) ?? '';
  }

  @override
  Future<void> logout() async {
    preferences.remove(tokenKey);
  }
}
