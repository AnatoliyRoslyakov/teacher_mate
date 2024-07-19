import 'package:calendar/calendar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_mate/core/models/request/lesson_delete_request.dart';
import 'package:teacher_mate/core/models/request/lesson_request.dart';
import 'package:teacher_mate/core/models/response/lesson_response.dart';
import 'package:teacher_mate/src/repository/lesson_repository/lesson_repository.dart';

part 'lesson_event.dart';
part 'lesson_state.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  final ILessonRepository lessonRepository;
  LessonBloc(this.lessonRepository) : super(LessonState.initial()) {
    on<LessonCreateEvent>(_create);
    on<LessonReadEvent>(_read);
    on<LessonUpdateEvent>(_update);
    on<LessonDeleteEvent>(_delete);
  }

// создание урока
  Future<void> _create(
      LessonCreateEvent event, Emitter<LessonState> emitter) async {
    await lessonRepository.addLesson([
      LessonRequest(
          description: event.description,
          studentId: event.studentId,
          start: event.start ~/ 1000,
          end: event.end ~/ 1000,
          userId: 1, // можно не передавать
          type: event.type - 1)
    ]);
    add(const LessonReadEvent());
  }

// получение урока
  Future<void> _read(
      LessonReadEvent event, Emitter<LessonState> emitter) async {
    emitter(state.copyWith(isLoading: true));
    List<LessonResponse> lessons =
        await lessonRepository.getListLessons('1', '2');

    List<LessonEntity> lesson = List.generate(
        lessons.length,
        (int index) => LessonEntity(
            description: lessons[index].description,
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
      LessonUpdateEvent event, Emitter<LessonState> emitter) async {}

  // удаление урока
  Future<void> _delete(
      LessonDeleteEvent event, Emitter<LessonState> emitter) async {
    await lessonRepository.deleteLesson(LessonDeleteRequest(id: event.id));
    add(const LessonReadEvent());
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
