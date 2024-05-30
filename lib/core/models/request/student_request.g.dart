// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentRequest _$StudentRequestFromJson(Map<String, dynamic> json) =>
    StudentRequest(
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
    );

Map<String, dynamic> _$StudentRequestToJson(StudentRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
    };
