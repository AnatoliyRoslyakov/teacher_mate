import 'package:calendar/calendar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_mate/core/models/request/lesson_delete_request.dart';
import 'package:teacher_mate/core/models/request/lesson_request.dart';
import 'package:teacher_mate/core/models/response/lesson_response.dart';
import 'package:teacher_mate/src/entity/calendar_settings.dart';
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
    on<CalendarSettingsEvent>(_settings);
  }

  Future<void> _create(
      CalendarCreateEvent event, Emitter<CalendarState> emitter) async {
    await calendarRepository.addLesson(LessonRequest(
        studentId: event.studentId,
        start: event.start ~/ 1000,
        end: event.end ~/ 1000,
        userId: 1,
        type: event.type - 1));
// лучше не запрашивать повторно, а просто добавить в Map, но пока так
    add(const CalendarReadEvent());
  }

  Future<void> _read(
      CalendarReadEvent event, Emitter<CalendarState> emitter) async {
    emitter(state.copyWith(isLoading: true));
    List<LessonResponse> lessons =
        await calendarRepository.getListLessons('1', '2');

    List<LessonEntity> lesson = List.generate(
        lessons.length,
        (int index) => LessonEntity(
            start: DateTime.fromMillisecondsSinceEpoch(
                lessons[index].start * 1000),
            end: DateTime.fromMillisecondsSinceEpoch(lessons[index].end * 1000),
            name: lessons[index].id.toString(),
            studentId: lessons[index].studentId,
            type: lessons[index].type,
            id: lessons[index].id));

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

  Future<void> _settings(
      CalendarSettingsEvent event, Emitter<CalendarState> emitter) async {
    emitter(state.copyWith(
        calendarSettings: CalendarSettingsEntity(
            minutesGrid: event.minutesGrid,
            startHour: event.startHour,
            endHour: event.endHour,
            viewDay: event.viewDay,
            startOfWeek: event.startOfWeek)));
  }
}

Map<DateTime, List<LessonEntity>> getItemsGroup(
  List<LessonEntity> data,
) {
  final result = <DateTime, List<LessonEntity>>{};

  for (final item in data) {
    final DateTime time = item.start.startOfDay();
    if (result[time] != null) {
      result[time]?.add(item);
    } else {
      result[time] = <LessonEntity>[item];
    }
  }

  final List<MapEntry<DateTime, List<LessonEntity>>> entries =
      result.entries.toList();

  entries.sort((b, a) => a.key.compareTo(b.key));

  final Map<DateTime, List<LessonEntity>> sortedMap = Map.fromEntries(
    entries.map((entry) {
      final value = entry.value;
      value.sort((b, a) => a.start.compareTo(b.start));
      return MapEntry(entry.key, entry.value);
    }),
  );

  return sortedMap;
}
