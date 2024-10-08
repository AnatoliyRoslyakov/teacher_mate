import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:teacher_mate/core/models/request/auth_request.dart';
import 'package:teacher_mate/core/models/request/lesson_delete_request.dart';
import 'package:teacher_mate/core/models/request/lesson_request.dart';
import 'package:teacher_mate/core/models/request/student_request.dart';
import 'package:teacher_mate/core/models/response/auth_response.dart';
import 'package:teacher_mate/core/models/response/lesson_response.dart';
import 'package:teacher_mate/core/models/response/student_response.dart';

part 'api_handler.g.dart';

@RestApi(
  parser: Parser.JsonSerializable,
)
abstract class ApiHandler {
  factory ApiHandler(Dio dio, {String baseUrl}) = _ApiHandler;

  @POST('/lesson')
  Future<String> addLesson(@Body() LessonRequest lessonRequest);

  @GET('/lesson')
  Future<List<LessonResponse>> getListLessons(
      @Query('start') String start, @Query('end') String end);

  @DELETE('/lesson')
  Future<String> deleteLesson(@Body() LessonDeleteRequest lessonDeleteRequest);

  @POST('/student')
  Future<String> addStudent(@Body() StudentRequest studentRequest);

  @GET('/student')
  Future<List<StudentResponse>> getListStudent();

  @POST('/login')
  Future<AuthResponse> login(@Body() AuthRequest authRequest);
}
