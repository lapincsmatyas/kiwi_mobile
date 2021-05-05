// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation-creation-dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsultationCreationDto _$ConsultationCreationDtoFromJson(
    Map<String, dynamic> json) {
  return ConsultationCreationDto(
    json['id'] as String?,
    json['startDate'] as int?,
    json['duration'] as int?,
    json['allDay'] as bool?,
    json['description'] as String?,
    json['taskId'] as String?,
    (json['expensesDTO'] as List<dynamic>?)
        ?.map((e) => Expense.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ConsultationCreationDtoToJson(
        ConsultationCreationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startDate': instance.startDate,
      'duration': instance.duration,
      'allDay': instance.allDay,
      'description': instance.description,
      'taskId': instance.taskId,
      'expensesDTO': instance.expensesDTO,
    };
