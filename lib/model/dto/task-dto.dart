import 'package:json_annotation/json_annotation.dart';
import 'package:kiwi_mobile/model/task.dart';

part 'task-dto.g.dart';

@JsonSerializable()
class TaskDto {
  final bool? successful;
  final String? message;
  final List<String>? messageParameters;
  final List<Task> data;

  TaskDto(this.successful, this.message, this.messageParameters, this.data);

  dynamic toJson() => _$TaskDtoToJson(this);
  factory TaskDto.fromJson(Map<String, dynamic> obj) => _$TaskDtoFromJson(obj);
}
