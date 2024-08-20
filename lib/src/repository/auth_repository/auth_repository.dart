import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_mate/core/api/api_handler.dart';
import 'package:teacher_mate/core/models/request/auth_request.dart';
import 'package:teacher_mate/core/models/response/auth_response.dart';

abstract class IAuthRepository {
  Future<String> checkAuth();
  Future<bool> checkFirstLaunch();

  Future<String> login({required String code});

  Future<void> logout();
}

const _tokenKey = 'tokenKey';
const _keyFirstStart = 'keyFirstLaunch';

class AuthRepository implements IAuthRepository {
  final ApiHandler apiHandler;
  final SharedPreferences preferences;

  AuthRepository(this.apiHandler, this.preferences);

  @override
  Future<bool> checkFirstLaunch() async {
    final isFirstStart = preferences.getBool(_keyFirstStart) ?? true;
    if (isFirstStart) {
      preferences.setBool(_keyFirstStart, false);
    }
    return isFirstStart;
  }

  @override
  Future<String> login({required String code}) async {
    final AuthResponse token = await apiHandler.login(AuthRequest(code: code));
    preferences.setString(_tokenKey, token.token);
    return token.token;
  }

  @override
  Future<String> checkAuth() async {
    return preferences.getString(_tokenKey) ?? '';
  }

  @override
  Future<void> logout() async {
    preferences.remove(_tokenKey);
  }
}
