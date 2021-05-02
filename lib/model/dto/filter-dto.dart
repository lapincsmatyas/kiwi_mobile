import 'package:json_annotation/json_annotation.dart';
import 'package:kiwi_mobile/model/consultation.dart';
import 'package:kiwi_mobile/model/task.dart';

part 'filter-dto.g.dart';

@JsonSerializable()
class FilterDto {
  final String? task;
  final int? pageNumber;
  final int? pageSize;
  final DateTime? startDate;
  final DateTime? endDate;
  final Map<String, String> orderParams;

  FilterDto(this.task, this.pageNumber, this.pageSize, this.startDate, this.endDate, this.orderParams);

  dynamic toJson() => _$FilterDtoToJson(this);
  factory FilterDto.fromJson(Map<String, dynamic> obj) => _$FilterDtoFromJson(obj);
}
