import 'package:json_annotation/json_annotation.dart';
import 'package:kiwi_mobile/model/task.dart';

import 'expense.dart';

part 'consultation.g.dart';

@JsonSerializable()
class Consultation {
  String? id;
  int? startDate;
  int? duration;
  bool? allDay;
  String? description;
  Task? taskDTO;
  String? taskId;
  List<Expense>? expensesDTO;

  Consultation(
      {this.id,
      this.startDate,
      this.duration,
      this.allDay,
      this.description,
      this.taskDTO,
      this.expensesDTO});

  dynamic toJson() => _$ConsultationToJson(this);

  factory Consultation.fromJson(Map<String, dynamic> obj) =>
      _$ConsultationFromJson(obj);
}
