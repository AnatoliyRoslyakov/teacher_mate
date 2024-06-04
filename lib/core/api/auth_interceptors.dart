import 'package:dio/dio.dart';
import 'package:teacher_mate/core/api/dio_auth_action.dart';

class AuthInterceptor extends Interceptor {
  AbstractDioAuthActions? authActions;

  AuthInterceptor({
    this.authActions,
  });

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      authActions?.onUnAuthedError();
    }
    handler.next(err);
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final requestOptions = _requestInterceptor(options);
    handler.next(requestOptions);
  }

  RequestOptions _requestInterceptor(RequestOptions options) {
    final token = authActions?.token;
    if (token != null) {
      options.headers.addAll(<String, String>{'authorization': token});
    } else {
      options.headers.remove('authorization');
    }
    return options;
  }
}
