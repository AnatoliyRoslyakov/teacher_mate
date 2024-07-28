import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState.initial()) {
    on<SettingsInitEvent>(_init);
    on<SettingsDefaultEvent>(_defaultSettings);
    on<SettingsGridEvent>(_grid);
    on<SettingsStartDayEvent>(_startDay);
    on<SettingsEndDayEvent>(_endDay);
    on<SettingsViewDaysEvent>(_viewDays);
    on<SettingsWeekEvent>(_week);
    on<SettingsThreeDaysEvent>(_threeDays);
    on<SettingsSaveEvent>(_save);
  }

  Future<void> _init(
      SettingsInitEvent event, Emitter<SettingsState> emitter) async {
    // при создании блока, проверка если сохраненные настройки?
    emitter(state.copyWith());
  }

  Future<void> _defaultSettings(
      SettingsDefaultEvent event, Emitter<SettingsState> emitter) async {
    emitter(SettingsState.initial());
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
    emitter(state.copyWith(week: event.week, three: false, viewDays: 7));
  }

  Future<void> _threeDays(
      SettingsThreeDaysEvent event, Emitter<SettingsState> emitter) async {
    emitter(state.copyWith(three: event.threeDays, week: false, viewDays: 3));
  }

  Future<void> _save(
      SettingsSaveEvent event, Emitter<SettingsState> emitter) async {
    // сохранение в локальное хранилище
    emitter(state.copyWith());
  }
}
