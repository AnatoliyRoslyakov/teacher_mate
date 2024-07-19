part of 'lesson_bloc.dart';

sealed class LessonEvent {
  const LessonEvent();

  const factory LessonEvent.create(
          int start, int end, int type, int studentId, String description) =
      LessonCreateEvent;

  const factory LessonEvent.read() = LessonReadEvent;

  const factory LessonEvent.update() = LessonUpdateEvent;

  const factory LessonEvent.delete(String id) = LessonDeleteEvent;
}

class LessonCreateEvent extends LessonEvent {
  final int start;
  final int end;
  final int type;
  final int studentId;
  final String description;
  const LessonCreateEvent(
      this.start, this.end, this.type, this.studentId, this.description);
}

class LessonReadEvent extends LessonEvent {
  const LessonReadEvent();
}

class LessonUpdateEvent extends LessonEvent {
  const LessonUpdateEvent();
}

class LessonDeleteEvent extends LessonEvent {
  final String id;
  const LessonDeleteEvent(this.id);
}
