import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  final String id;
  final String code;
  final String? description;
  final String? taskStatus;
  final String? taskType;

  Task(this.id, this.code, this.description, this.taskStatus, this.taskType);

  bool operator ==(Object other) {
    if (identical(this, other))
      return true;
    if(!(other is Task))
      return false;
    else return other.id == id;
  }

  dynamic toJson() => _$TaskToJson(this);
  factory Task.fromJson(Map<String, dynamic> obj) => _$TaskFromJson(obj);

  @override
  int get hashCode => id.hashCode^code.hashCode^description.hashCode^taskStatus.hashCode^taskType.hashCode;

}