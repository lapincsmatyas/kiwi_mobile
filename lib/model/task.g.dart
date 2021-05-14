// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task(
    json['id'] as String,
    json['code'] as String,
    json['description'] as String?,
    json['taskStatus'] as String?,
    json['taskType'] as String?,
  );
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'description': instance.description,
      'taskStatus': instance.taskStatus,
      'taskType': instance.taskType,
    };
