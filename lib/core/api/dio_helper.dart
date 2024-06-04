import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:teacher_mate/core/api/auth_interceptors.dart';

class DioHelper {
  final Dio dio;
  final AuthInterceptor authInterceptor;

  DioHelper({required this.authInterceptor}) : dio = Dio() {
    _initDio();
  }

  void _initDio() {
    const Map<String, String> headers = {'Content-Type': 'application/json'};
    dio.options.headers = headers;
    dio.interceptors.add(authInterceptor);
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        logPrint: (object) {
          if (kDebugMode) {
            log(object.toString());
          }
        },
      ),
    );
  }
}
