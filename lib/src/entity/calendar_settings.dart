class CalendarSettingsEntity {
  final double minutesGrid;
  final int startHour;
  final int endHour;
  final int viewDay;
  final bool startOfWeek;

  CalendarSettingsEntity({
    required this.minutesGrid,
    required this.startHour,
    required this.endHour,
    required this.viewDay,
    required this.startOfWeek,
  });

  factory CalendarSettingsEntity.initial() => CalendarSettingsEntity(
      minutesGrid: 0.5,
      startHour: 9,
      endHour: 23,
      viewDay: 7,
      startOfWeek: true);

  CalendarSettingsEntity copyWith({
    double? minutesGrid,
    int? startHour,
    int? endHour,
    int? viewDay,
    bool? startOfWeek,
  }) {
    return CalendarSettingsEntity(
      minutesGrid: minutesGrid ?? this.minutesGrid,
      startHour: startHour ?? this.startHour,
      endHour: endHour ?? this.endHour,
      viewDay: viewDay ?? this.viewDay,
      startOfWeek: startOfWeek ?? this.startOfWeek,
    );
  }
}
