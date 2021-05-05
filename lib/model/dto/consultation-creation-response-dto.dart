import 'package:json_annotation/json_annotation.dart';
import 'package:kiwi_mobile/model/consultation.dart';
import 'package:kiwi_mobile/model/task.dart';

import '../expense.dart';

part 'consultation-creation-response-dto.g.dart';

@JsonSerializable()
class ConsultationCreationResponseDto {
  bool? successful;
  String? message;
  List<String>? messageParameters;
  String? data;

  ConsultationCreationResponseDto();

  dynamic toJson() => _$ConsultationCreationResponseDtoToJson(this);
  factory ConsultationCreationResponseDto.fromJson(Map<String, dynamic> obj) => _$ConsultationCreationResponseDtoFromJson(obj);
}
