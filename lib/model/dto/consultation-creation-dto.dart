import 'package:json_annotation/json_annotation.dart';
import 'package:kiwi_mobile/model/consultation.dart';
import 'package:kiwi_mobile/model/task.dart';

import '../expense.dart';

part 'consultation-creation-dto.g.dart';

@JsonSerializable()
class ConsultationCreationDto {
  String? id;
  int? startDate;
  int? duration;
  bool? allDay;
  String? description;
  String? taskId;
  List<Expense>? expensesDTO;

  ConsultationCreationDto(this.id, this.startDate, this.duration, this.allDay, this.description, this.taskId, this.expensesDTO);

  dynamic toJson() => _$ConsultationCreationDtoToJson(this);
  factory ConsultationCreationDto.fromJson(Map<String, dynamic> obj) => _$ConsultationCreationDtoFromJson(obj);
}
