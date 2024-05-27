part of 'calendar_bloc.dart';

sealed class CalendarEvent {
  const CalendarEvent();

  const factory CalendarEvent.create(DateTime start, DateTime end) =
      CalendarCreateEvent;

  const factory CalendarEvent.read() = CalendarReadEvent;

  const factory CalendarEvent.update() = CalendarUpdateEvent;

  const factory CalendarEvent.delete() = CalendarDeleteEvent;
}

class CalendarCreateEvent extends CalendarEvent {
  final DateTime start;
  final DateTime end;
  const CalendarCreateEvent(this.start, this.end);
}

class CalendarReadEvent extends CalendarEvent {
  const CalendarReadEvent();
}

class CalendarUpdateEvent extends CalendarEvent {
  const CalendarUpdateEvent();
}

class CalendarDeleteEvent extends CalendarEvent {
  const CalendarDeleteEvent();
}
