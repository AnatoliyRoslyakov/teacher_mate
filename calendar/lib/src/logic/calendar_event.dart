part of 'calendar_bloc.dart';

sealed class CalendarEvent {
  const CalendarEvent();

  const factory CalendarEvent.create() = CalendarCreateEvent;

  const factory CalendarEvent.read() = CalendarReadEvent;

  const factory CalendarEvent.update() = CalendarUpdateEvent;

  const factory CalendarEvent.delete() = CalendarDeleteEvent;
}

class CalendarCreateEvent extends CalendarEvent {
  const CalendarCreateEvent();
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
