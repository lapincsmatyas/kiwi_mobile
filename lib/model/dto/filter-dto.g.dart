// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter-dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterDto _$FilterDtoFromJson(Map<String, dynamic> json) {
  return FilterDto(
    json['task'] as String?,
    json['pageNumber'] as int?,
    json['pageSize'] as int?,
    json['startDate'] == null
        ? null
        : DateTime.parse(json['startDate'] as String),
    json['endDate'] == null ? null : DateTime.parse(json['endDate'] as String),
    Map<String, String>.from(json['orderParams'] as Map),
  );
}

Map<String, dynamic> _$FilterDtoToJson(FilterDto instance) => <String, dynamic>{
      'task': instance.task,
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'orderParams': instance.orderParams,
    };
