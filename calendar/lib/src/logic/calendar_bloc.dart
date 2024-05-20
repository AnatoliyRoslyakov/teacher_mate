import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarState.initial()) {
    on<CalendarCreateEvent>(_create);
    on<CalendarReadEvent>(_read);
    on<CalendarUpdateEvent>(_update);
    on<CalendarDeleteEvent>(_delete);
  }

  Future<void> _create(
      CalendarCreateEvent event, Emitter<CalendarState> emitter) async {}

  Future<void> _read(
      CalendarReadEvent event, Emitter<CalendarState> emitter) async {}

  Future<void> _update(
      CalendarUpdateEvent event, Emitter<CalendarState> emitter) async {}
  Future<void> _delete(
      CalendarDeleteEvent event, Emitter<CalendarState> emitter) async {}
}
