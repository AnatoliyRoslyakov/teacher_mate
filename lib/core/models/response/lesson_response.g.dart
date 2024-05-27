// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonResponse _$LessonResponseFromJson(Map<String, dynamic> json) =>
    LessonResponse(
      studentId: (json['studentId'] as num).toInt(),
      start: (json['start'] as num).toInt(),
      end: (json['end'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      type: (json['type'] as num).toInt(),
    );

Map<String, dynamic> _$LessonResponseToJson(LessonResponse instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'start': instance.start,
      'end': instance.end,
      'userId': instance.userId,
      'type': instance.type,
    };
