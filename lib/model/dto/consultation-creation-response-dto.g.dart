// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation-creation-response-dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsultationCreationResponseDto _$ConsultationCreationResponseDtoFromJson(
    Map<String, dynamic> json) {
  return ConsultationCreationResponseDto()
    ..successful = json['successful'] as bool?
    ..message = json['message'] as String?
    ..messageParameters = (json['messageParameters'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList()
    ..data = json['data'] as String?;
}

Map<String, dynamic> _$ConsultationCreationResponseDtoToJson(
        ConsultationCreationResponseDto instance) =>
    <String, dynamic>{
      'successful': instance.successful,
      'message': instance.message,
      'messageParameters': instance.messageParameters,
      'data': instance.data,
    };
