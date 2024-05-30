// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'calendar_bloc.dart';

class CalendarState {
  final Map<DateTime, List<LessonEntity>> mapLessons;
  final bool isLoading;
  final CalendarSettingsEntity calendarSettings;
  const CalendarState({
    required this.calendarSettings,
    required this.mapLessons,
    required this.isLoading,
  });
  factory CalendarState.initial() => CalendarState(
        mapLessons: {},
        isLoading: false,
        calendarSettings: CalendarSettingsEntity.initial(),
      );

  CalendarState copyWith({
    Map<DateTime, List<LessonEntity>>? mapLessons,
    bool? isLoading,
    CalendarSettingsEntity? calendarSettings,
  }) {
    return CalendarState(
      mapLessons: mapLessons ?? this.mapLessons,
      isLoading: isLoading ?? this.isLoading,
      calendarSettings: calendarSettings ?? this.calendarSettings,
    );
  }
}
