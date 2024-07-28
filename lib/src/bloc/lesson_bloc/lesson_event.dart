part of 'lesson_bloc.dart';

sealed class LessonEvent {
  const LessonEvent();

  const factory LessonEvent.create(
      {required int start,
      required int end,
      required int type,
      required int studentId,
      required String description}) = LessonCreateEvent;

  const factory LessonEvent.read() = LessonReadEvent;

  const factory LessonEvent.update(
      {required int id,
      required int start,
      required int end,
      required int type,
      required int studentId,
      required String description}) = LessonUpdateEvent;

  const factory LessonEvent.delete(String id) = LessonDeleteEvent;
}

class LessonCreateEvent extends LessonEvent {
  final int start;
  final int end;
  final int type;
  final int studentId;
  final String description;
  const LessonCreateEvent({
    required this.start,
    required this.end,
    required this.type,
    required this.studentId,
    required this.description,
  });
}

class LessonReadEvent extends LessonEvent {
  const LessonReadEvent();
}

class LessonUpdateEvent extends LessonEvent {
  final int id;
  final int start;
  final int end;
  final int type;
  final int studentId;
  final String description;
  const LessonUpdateEvent(
      {required this.start,
      required this.end,
      required this.type,
      required this.studentId,
      required this.description,
      required this.id});
}

class LessonDeleteEvent extends LessonEvent {
  final String id;
  const LessonDeleteEvent(this.id);
}
