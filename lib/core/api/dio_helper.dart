import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sentry_dio/sentry_dio.dart';

class DioHelper {
  final Dio dio;

  DioHelper() : dio = Dio() {
    _initDio();
  }

  void _initDio() {
    const Map<String, String> headers = {
      'authorization':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MTkzMDE1NzIsImlhdCI6MTcxNjYyMzE3MiwiaWQiOjIsImlzcyI6Ik15QXBwIiwic3ViIjoiZXhhbXBsZUBleGFtcGxlLmNvbSIsInVzZXJuYW1lIjoicG9zdG1hbn0ifQ.KDnrDfuAZv-cHIZvdubo5l3Ccc9ZU2SCtjVsrJJIy0Q'
    };
    dio.options.headers = headers;

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
    dio.addSentry();
  }
}
