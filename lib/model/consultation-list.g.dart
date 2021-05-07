// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation-list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsultationList _$ConsultationListFromJson(Map<String, dynamic> json) {
  return ConsultationList(
    consultations: (json['consultations'] as List<dynamic>?)
        ?.map((e) => Consultation.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ConsultationListToJson(ConsultationList instance) =>
    <String, dynamic>{
      'consultations': instance.consultations,
    };
