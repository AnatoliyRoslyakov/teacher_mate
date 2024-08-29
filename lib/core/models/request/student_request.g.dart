// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentRequest _$StudentRequestFromJson(Map<String, dynamic> json) =>
    StudentRequest(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      tgName: json['tgName'] as String,
    );

Map<String, dynamic> _$StudentRequestToJson(StudentRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'tgName': instance.tgName,
    };
