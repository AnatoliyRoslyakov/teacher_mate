import 'package:teacher_mate/core/api/api_handler.dart';
import 'package:teacher_mate/core/models/request/lesson_delete_request.dart';
import 'package:teacher_mate/core/models/request/lesson_request.dart';
import 'package:teacher_mate/core/models/response/lesson_response.dart';

abstract class ILessonRepository {
  Future<String> addLesson(List<LessonRequest> lessonRequest);

  Future<List<LessonResponse>> getListLessons(String start, String end);
  Future<String> deleteLesson(LessonDeleteRequest lessonDeleteRequest);
}

class LessonRepository extends ILessonRepository {
  final ApiHandler apiHandler;
  LessonRepository(this.apiHandler);

  @override
  Future<String> addLesson(List<LessonRequest> lessonRequest) {
    return apiHandler.addLesson(lessonRequest);
  }

  @override
  Future<List<LessonResponse>> getListLessons(String start, String end) {
    return apiHandler.getListLessons(start, end);
  }

  @override
  Future<String> deleteLesson(LessonDeleteRequest lessonDeleteRequest) {
    return apiHandler.deleteLesson(lessonDeleteRequest);
  }
}
