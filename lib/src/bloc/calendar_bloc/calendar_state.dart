// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'calendar_bloc.dart';

class CalendarState {
  final Map<DateTime, List<Lesson>> mapLessons;
  final bool isLoading;
  const CalendarState({
    required this.mapLessons,
    required this.isLoading,
  });
  factory CalendarState.initial() => const CalendarState(
        mapLessons: {},
        isLoading: false,
      );

  CalendarState copyWith({
    Map<DateTime, List<Lesson>>? mapLessons,
    bool? isLoading,
  }) {
    return CalendarState(
      mapLessons: mapLessons ?? this.mapLessons,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
