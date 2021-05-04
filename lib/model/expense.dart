import 'package:json_annotation/json_annotation.dart';

part 'expense.g.dart';

@JsonSerializable()
class Expense {
  String? description;

  Expense({this.description = ""});

  dynamic toJson() => _$ExpenseToJson(this);
  factory Expense.fromJson(Map<String, dynamic> obj) => _$ExpenseFromJson(obj);
}