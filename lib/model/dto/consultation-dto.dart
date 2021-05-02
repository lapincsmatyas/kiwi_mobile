import 'package:json_annotation/json_annotation.dart';
import 'package:kiwi_mobile/model/consultation.dart';
import 'package:kiwi_mobile/model/task.dart';

part 'consultation-dto.g.dart';

@JsonSerializable()
class ConsultationDto {
  final bool? successful;
  final String? message;
  final List<String>? messageParameters;
  final List<Consultation>? data;
  final int? allCount;

  ConsultationDto(this.successful, this.message, this.messageParameters, this.data, this.allCount);

  dynamic toJson() => _$ConsultationDtoToJson(this);
  factory ConsultationDto.fromJson(Map<String, dynamic> obj) => _$ConsultationDtoFromJson(obj);
}
