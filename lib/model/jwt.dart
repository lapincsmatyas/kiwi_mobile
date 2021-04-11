import 'package:json_annotation/json_annotation.dart';

part 'jwt.g.dart';

@JsonSerializable()
class JWT {
  final String? access_token;
  final int? expires_in;
  final int? refresh_expires_in;
  final String? refresh_token;
  final String? token_type;
  final String? id_token;

  @JsonKey(name: "not-before-policy")
  final int? not_before_policy;

  final String? session_state;
  final String? scope;

  JWT(this.access_token, this.expires_in, this.refresh_expires_in, this.refresh_token, this.token_type, this.id_token, this.not_before_policy, this.session_state, this.scope);


  dynamic toJson() => _$JWTToJson(this);
  factory JWT.fromJson(Map<String, dynamic> obj) => _$JWTFromJson(obj);
}