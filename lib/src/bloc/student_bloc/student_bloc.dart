import 'package:calendar/calendar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_mate/core/models/request/student_delete_request.dart';
import 'package:teacher_mate/core/models/request/student_request.dart';
import 'package:teacher_mate/src/repository/student_repository/student_repository.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  IStudentRepository studentRepository;
  StudentBloc(
    this.studentRepository,
  ) : super(StudentState.initial()) {
    on<StudentCreateEvent>(_create);
    on<StudentReadEvent>(_read);
    on<StudentUpdateEvent>(_update);
    on<StudentDeleteEvent>(_delete);
  }

  Future<void> _create(
      StudentCreateEvent event, Emitter<StudentState> emitter) async {
    await studentRepository
        .addStudent(StudentRequest(name: event.name, price: event.price));
    add(const StudentReadEvent());
  }

  Future<void> _read(
      StudentReadEvent event, Emitter<StudentState> emitter) async {
    emitter(state.copyWith(isLoading: true));
    final data = await studentRepository.getListStudent();
    final studentEntity = List.generate(data.length, (i) {
      return StudentEntity(
          id: data[i].id, name: data[i].name, price: data[i].price);
    });
    emitter(state.copyWith(isLoading: false, studentEntity: studentEntity));
  }

  Future<void> _update(
      StudentUpdateEvent event, Emitter<StudentState> emitter) async {
    await studentRepository.updateStudent(
        [StudentRequest(id: event.id, name: event.name, price: event.price)]);
    add(const StudentReadEvent());
  }

  Future<void> _delete(
      StudentDeleteEvent event, Emitter<StudentState> emitter) async {
    await studentRepository.deleteStudent(StudentDeleteRequest(id: event.id));
    add(const StudentReadEvent());
  }
}
