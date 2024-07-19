part of 'settings_bloc.dart';

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
