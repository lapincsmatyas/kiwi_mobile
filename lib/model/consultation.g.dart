// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Consultation _$ConsultationFromJson(Map<String, dynamic> json) {
  return Consultation(
    id: json['id'] as String?,
    startDate: json['startDate'] as int?,
    duration: json['duration'] as int?,
    allDay: json['allDay'] as bool?,
    description: json['description'] as String?,
    taskDTO: json['taskDTO'] == null
        ? null
        : Task.fromJson(json['taskDTO'] as Map<String, dynamic>),
    expensesDTO: (json['expensesDTO'] as List<dynamic>?)
        ?.map((e) => Expense.fromJson(e as Map<String, dynamic>))
        .toList(),
  )..taskId = json['taskId'] as String?;
}

Map<String, dynamic> _$ConsultationToJson(Consultation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startDate': instance.startDate,
      'duration': instance.duration,
      'allDay': instance.allDay,
      'description': instance.description,
      'taskDTO': instance.taskDTO,
      'taskId': instance.taskId,
      'expensesDTO': instance.expensesDTO,
    };
