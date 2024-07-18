part of 'calendar_bloc.dart';

sealed class CalendarEvent {
  const CalendarEvent();

  const factory CalendarEvent.create(
      int start, int end, int type, int studentId) = CalendarCreateEvent;

  const factory CalendarEvent.read() = CalendarReadEvent;

  const factory CalendarEvent.update() = CalendarUpdateEvent;

  const factory CalendarEvent.delete(String id) = CalendarDeleteEvent;
}

class CalendarCreateEvent extends CalendarEvent {
  final int start;
  final int end;
  final int type;
  final int studentId;
  const CalendarCreateEvent(this.start, this.end, this.type, this.studentId);
}

class CalendarReadEvent extends CalendarEvent {
  const CalendarReadEvent();
}

class CalendarUpdateEvent extends CalendarEvent {
  const CalendarUpdateEvent();
}

class CalendarDeleteEvent extends CalendarEvent {
  final String id;
  const CalendarDeleteEvent(this.id);
}
