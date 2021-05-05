// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task-list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskList _$TaskListFromJson(Map<String, dynamic> json) {
  return TaskList(
    tasks: (json['tasks'] as List<dynamic>?)
        ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$TaskListToJson(TaskList instance) => <String, dynamic>{
      'tasks': instance.tasks,
    };
