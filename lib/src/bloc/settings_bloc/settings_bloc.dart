import 'package:flutter_bloc/flutter_bloc.dart';

sealed class SettingsEvent {
  const SettingsEvent();

  const factory SettingsEvent.init() = SettingsInitEvent;
  const factory SettingsEvent.defaultSettings() = SettingsDefaultEvent;

  const factory SettingsEvent.grid({required double minutesGrid}) =
      SettingsGridEvent;

  const factory SettingsEvent.startDay({required int startDay}) =
      SettingsStartDayEvent;

  const factory SettingsEvent.endDay({required int endDay}) =
      SettingsEndDayEvent;

  const factory SettingsEvent.viewDays({required int viewDays}) =
      SettingsViewDaysEvent;

  const factory SettingsEvent.week({required bool week}) = SettingsWeekEvent;

  const factory SettingsEvent.save() = SettingsSaveEvent;
}

class SettingsInitEvent extends SettingsEvent {
  const SettingsInitEvent();
}

class SettingsDefaultEvent extends SettingsEvent {
  const SettingsDefaultEvent();
}

class SettingsGridEvent extends SettingsEvent {
  final double minutesGrid;
  const SettingsGridEvent({required this.minutesGrid});
}

class SettingsStartDayEvent extends SettingsEvent {
  final int startDay;
  const SettingsStartDayEvent({required this.startDay});
}

class SettingsEndDayEvent extends SettingsEvent {
  final int endDay;
  const SettingsEndDayEvent({required this.endDay});
}

class SettingsViewDaysEvent extends SettingsEvent {
  final int viewDays;
  const SettingsViewDaysEvent({required this.viewDays});
}

class SettingsWeekEvent extends SettingsEvent {
  final bool week;
  const SettingsWeekEvent({required this.week});
}

class SettingsSaveEvent extends SettingsEvent {
  const SettingsSaveEvent();
}

class SettingsState {
  final double minutesGrid;
  final int startDay;
  final int endDay;
  final int viewDays;
  final bool week;
  const SettingsState({
    required this.minutesGrid,
    required this.startDay,
    required this.endDay,
    required this.viewDays,
    required this.week,
  });
  factory SettingsState.initial() => const SettingsState(
      minutesGrid: 0.5, startDay: 9, endDay: 23, viewDays: 7, week: true);

  SettingsState copyWith({
    double? minutesGrid,
    int? startDay,
    int? endDay,
    int? viewDays,
    bool? week,
  }) {
    return SettingsState(
      minutesGrid: minutesGrid ?? this.minutesGrid,
      startDay: startDay ?? this.startDay,
      endDay: endDay ?? this.endDay,
      viewDays: viewDays ?? this.viewDays,
      week: week ?? this.week,
    );
  }
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState.initial()) {
    on<SettingsInitEvent>(_init);
    on<SettingsDefaultEvent>(_defaultSettings);
    on<SettingsGridEvent>(_grid);
    on<SettingsStartDayEvent>(_startDay);
    on<SettingsEndDayEvent>(_endDay);
    on<SettingsViewDaysEvent>(_viewDays);
    on<SettingsWeekEvent>(_week);
    on<SettingsSaveEvent>(_save);
  }

  Future<void> _init(
      SettingsInitEvent event, Emitter<SettingsState> emitter) async {
    // при создании блока, проверка если сохраненные настройки?
    emitter(state.copyWith());
  }

  Future<void> _defaultSettings(
      SettingsDefaultEvent event, Emitter<SettingsState> emitter) async {
    emitter(state.copyWith(
        minutesGrid: 0.5, endDay: 23, startDay: 9, week: true, viewDays: 7));
  }

  Future<void> _grid(
      SettingsGridEvent event, Emitter<SettingsState> emitter) async {
    emitter(state.copyWith(minutesGrid: event.minutesGrid));
  }

  Future<void> _startDay(
      SettingsStartDayEvent event, Emitter<SettingsState> emitter) async {
    emitter(state.copyWith(startDay: event.startDay));
  }

  Future<void> _endDay(
      SettingsEndDayEvent event, Emitter<SettingsState> emitter) async {
    emitter(state.copyWith(endDay: event.endDay));
  }

  Future<void> _viewDays(
      SettingsViewDaysEvent event, Emitter<SettingsState> emitter) async {
    emitter(state.copyWith(viewDays: event.viewDays));
  }

  Future<void> _week(
      SettingsWeekEvent event, Emitter<SettingsState> emitter) async {
    emitter(state.copyWith(week: event.week));
  }

  Future<void> _save(
      SettingsSaveEvent event, Emitter<SettingsState> emitter) async {
    // сохранение в локальное хранилище
    emitter(state.copyWith());
  }
}
