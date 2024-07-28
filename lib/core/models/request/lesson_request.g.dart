// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonRequest _$LessonRequestFromJson(Map<String, dynamic> json) =>
    LessonRequest(
      id: (json['id'] as num?)?.toInt() ?? 0,
      description: json['description'] as String,
      studentId: (json['studentId'] as num).toInt(),
      start: (json['start'] as num).toInt(),
      end: (json['end'] as num).toInt(),
      type: (json['type'] as num).toInt(),
    );

Map<String, dynamic> _$LessonRequestToJson(LessonRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'start': instance.start,
      'end': instance.end,
      'type': instance.type,
      'description': instance.description,
    };
