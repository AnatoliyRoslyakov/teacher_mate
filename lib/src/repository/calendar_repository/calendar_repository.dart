import 'package:teacher_mate/core/api/api_handler.dart';
import 'package:teacher_mate/core/models/request/lesson_request.dart';
import 'package:teacher_mate/core/models/response/lesson_response.dart';

abstract class ICalendarRepository {
  Future<String> addLesson(LessonRequest lessonRequest);

  Future<List<LessonResponse>> getListLessons(String start, String end);
}

class CalendarRepository extends ICalendarRepository {
  final ApiHandler apiHandler;
  CalendarRepository(this.apiHandler);

  @override
  Future<String> addLesson(LessonRequest lessonRequest) {
    return apiHandler.addLesson(lessonRequest);
  }

  @override
  Future<List<LessonResponse>> getListLessons(String start, String end) {
    return apiHandler.getListLessons(start, end);
  }
}
