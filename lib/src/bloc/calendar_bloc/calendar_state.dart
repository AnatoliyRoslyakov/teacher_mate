// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'calendar_bloc.dart';

class CalendarState {
  final List<LessonEntity> listLessons;
  final bool isLoading;
  const CalendarState({
    required this.listLessons,
    required this.isLoading,
  });
  factory CalendarState.initial() => const CalendarState(
        listLessons: [],
        isLoading: false,
      );

  CalendarState copyWith({
    List<LessonEntity>? listLessons,
    bool? isLoading,
  }) {
    return CalendarState(
      listLessons: listLessons ?? this.listLessons,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
