import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  final String? id;
  final String? code;
  final String? description;
  final String? taskStatus;
  final String? taskType;

  Task(this.id, this.code, this.description, this.taskStatus, this.taskType);

  dynamic toJson() => _$TaskToJson(this);
  factory Task.fromJson(Map<String, dynamic> obj) => _$TaskFromJson(obj);
}