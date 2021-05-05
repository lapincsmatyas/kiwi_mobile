// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation-dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsultationDto _$ConsultationDtoFromJson(Map<String, dynamic> json) {
  return ConsultationDto(
    json['successful'] as bool?,
    json['message'] as String?,
    (json['messageParameters'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    (json['data'] as List<dynamic>?)
        ?.map((e) => Consultation.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['allCount'] as int?,
  );
}

Map<String, dynamic> _$ConsultationDtoToJson(ConsultationDto instance) =>
    <String, dynamic>{
      'successful': instance.successful,
      'message': instance.message,
      'messageParameters': instance.messageParameters,
      'data': instance.data,
      'allCount': instance.allCount,
    };
