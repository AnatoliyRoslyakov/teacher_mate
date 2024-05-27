import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:teacher_mate/core/models/request/lesson_request.dart';
import 'package:teacher_mate/core/models/response/lesson_response.dart';

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
}
