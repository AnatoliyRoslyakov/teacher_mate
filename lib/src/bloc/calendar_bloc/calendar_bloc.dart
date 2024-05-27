import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_mate/core/models/request/lesson_request.dart';
import 'package:teacher_mate/core/models/response/lesson_response.dart';
import 'package:teacher_mate/src/entity/lesson.dart';
import 'package:teacher_mate/src/repository/calendar_repository/calendar_repository.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final ICalendarRepository calendarRepository;
  CalendarBloc(this.calendarRepository) : super(CalendarState.initial()) {
    on<CalendarCreateEvent>(_create);
    on<CalendarReadEvent>(_read);
    on<CalendarUpdateEvent>(_update);
    on<CalendarDeleteEvent>(_delete);
  }

  Future<void> _create(
      CalendarCreateEvent event, Emitter<CalendarState> emitter) async {
    await calendarRepository.addLesson(LessonRequest(
        studentId: 1,
        start: event.start.millisecondsSinceEpoch ~/ 1000,
        end: event.end.millisecondsSinceEpoch ~/ 1000,
        userId: 1,
        type: 1));

    add(const CalendarReadEvent());
  }

  Future<void> _read(
      CalendarReadEvent event, Emitter<CalendarState> emitter) async {
    emitter(state.copyWith(isLoading: true));
    List<LessonResponse> lessons =
        await calendarRepository.getListLessons('1', '2');
    List<LessonEntity> lessonsEntity = List.generate(lessons.length,
        (int index) => LessonEntity.fromEntity(lessonResponse: lessons[index]));

    emitter(
      state.copyWith(listLessons: lessonsEntity, isLoading: false),
    );
  }

  Future<void> _update(
      CalendarUpdateEvent event, Emitter<CalendarState> emitter) async {}
  Future<void> _delete(
      CalendarDeleteEvent event, Emitter<CalendarState> emitter) async {}
}
