// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task-dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskDto _$TaskDtoFromJson(Map<String, dynamic> json) {
  return TaskDto(
    json['successful'] as bool?,
    json['message'] as String?,
    (json['messageParameters'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    (json['data'] as List<dynamic>)
        .map((e) => Task.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$TaskDtoToJson(TaskDto instance) => <String, dynamic>{
      'successful': instance.successful,
      'message': instance.message,
      'messageParameters': instance.messageParameters,
      'data': instance.data,
    };
