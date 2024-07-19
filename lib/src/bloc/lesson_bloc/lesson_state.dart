// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'lesson_bloc.dart';

class LessonState {
  final Map<DateTime, List<LessonEntity>> mapLessons;
  final bool isLoading;
  const LessonState({
    required this.mapLessons,
    required this.isLoading,
  });
  factory LessonState.initial() => const LessonState(
        mapLessons: {},
        isLoading: false,
      );

  LessonState copyWith({
    Map<DateTime, List<LessonEntity>>? mapLessons,
    bool? isLoading,
  }) {
    return LessonState(
      mapLessons: mapLessons ?? this.mapLessons,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
