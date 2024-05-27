import 'package:calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_mate/core/models/request/lesson_delete_request.dart';
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
        start: event.start ~/ 1000,
        end: event.end ~/ 1000,
        userId: 1,
        type: 1));
// лучше не запрашивать повторно, а просто добавить в Map, но пока так
    add(const CalendarReadEvent());
  }

  Future<void> _read(
      CalendarReadEvent event, Emitter<CalendarState> emitter) async {
    emitter(state.copyWith(isLoading: true));
    List<LessonResponse> lessons =
        await calendarRepository.getListLessons('1', '2');

    List<Lesson> lesson = List.generate(
        lessons.length,
        (int index) => Lesson(
            start: DateTime.fromMillisecondsSinceEpoch(
                lessons[index].start * 1000),
            end: DateTime.fromMillisecondsSinceEpoch(lessons[index].end * 1000),
            name: lessons[index].id.toString()));

    emitter(
      state.copyWith(mapLessons: getItemsGroup(lesson), isLoading: false),
    );
  }

  Future<void> _update(
      CalendarUpdateEvent event, Emitter<CalendarState> emitter) async {}
  Future<void> _delete(
      CalendarDeleteEvent event, Emitter<CalendarState> emitter) async {
    await calendarRepository.deleteLesson(LessonDeleteRequest(id: event.id));
// лучше не запрашивать повторно, а просто добавить в Map, но пока так
    add(const CalendarReadEvent());
  }
}

Map<DateTime, List<Lesson>> getItemsGroup(
  List<Lesson> data,
) {
  final result = <DateTime, List<Lesson>>{};

  for (final item in data) {
    final DateTime time = item.start.startOfDay();
    if (result[time] != null) {
      result[time]?.add(item);
    } else {
      result[time] = <Lesson>[item];
    }
  }

  final List<MapEntry<DateTime, List<Lesson>>> entries =
      result.entries.toList();

  entries.sort((b, a) => a.key.compareTo(b.key));

  final Map<DateTime, List<Lesson>> sortedMap = Map.fromEntries(
    entries.map((entry) {
      final value = entry.value;
      value.sort((b, a) => a.start.compareTo(b.start));
      return MapEntry(entry.key, entry.value);
    }),
  );

  return sortedMap;
}
