import 'package:teacher_mate/core/api/api_handler.dart';
import 'package:teacher_mate/core/models/request/student_request.dart';
import 'package:teacher_mate/core/models/response/student_response.dart';

abstract class IStudentRepository {
  Future<String> addStudent(StudentRequest studentRequest);
  Future<List<StudentResponse>> getListStudent();
  // Future<String> deleteStudent(StudentDeleteRequest studentDeleteRequest);
}

class StudentRepository extends IStudentRepository {
  final ApiHandler apiHandler;
  StudentRepository(this.apiHandler);

  @override
  Future<String> addStudent(StudentRequest studentRequest) {
    return apiHandler.addStudent(studentRequest);
  }

  @override
  Future<List<StudentResponse>> getListStudent() {
    return apiHandler.getListStudent();
  }
}
