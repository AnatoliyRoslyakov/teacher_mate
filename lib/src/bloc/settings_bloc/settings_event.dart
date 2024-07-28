part of 'settings_bloc.dart';

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

  const factory SettingsEvent.threeDays({required bool threeDays}) =
      SettingsThreeDaysEvent;

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

class SettingsThreeDaysEvent extends SettingsEvent {
  final bool threeDays;
  const SettingsThreeDaysEvent({required this.threeDays});
}

class SettingsSaveEvent extends SettingsEvent {
  const SettingsSaveEvent();
}
