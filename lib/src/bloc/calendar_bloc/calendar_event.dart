part of 'calendar_bloc.dart';

sealed class CalendarEvent {
  const CalendarEvent();

  const factory CalendarEvent.create(int start, int end) = CalendarCreateEvent;

  const factory CalendarEvent.read() = CalendarReadEvent;

  const factory CalendarEvent.update() = CalendarUpdateEvent;

  const factory CalendarEvent.delete(String id) = CalendarDeleteEvent;

  const factory CalendarEvent.settings(
    double minutesGrid,
    int startHour,
    int endHour,
    int viewDay,
    bool startOfWeek,
  ) = CalendarSettingsEvent;
}

class CalendarCreateEvent extends CalendarEvent {
  final int start;
  final int end;
  const CalendarCreateEvent(this.start, this.end);
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

class CalendarSettingsEvent extends CalendarEvent {
  final double minutesGrid;
  final int startHour;
  final int endHour;
  final int viewDay;
  final bool startOfWeek;
  const CalendarSettingsEvent(this.minutesGrid, this.startHour, this.endHour,
      this.viewDay, this.startOfWeek);
}
