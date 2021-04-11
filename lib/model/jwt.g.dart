// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jwt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JWT _$JWTFromJson(Map<String, dynamic> json) {
  return JWT(
    json['access_token'] as String?,
    json['expires_in'] as int?,
    json['refresh_expires_in'] as int?,
    json['refresh_token'] as String?,
    json['token_type'] as String?,
    json['id_token'] as String?,
    json['not-before-policy'] as int?,
    json['session_state'] as String?,
    json['scope'] as String?,
  );
}

Map<String, dynamic> _$JWTToJson(JWT instance) => <String, dynamic>{
      'access_token': instance.access_token,
      'expires_in': instance.expires_in,
      'refresh_expires_in': instance.refresh_expires_in,
      'refresh_token': instance.refresh_token,
      'token_type': instance.token_type,
      'id_token': instance.id_token,
      'not-before-policy': instance.not_before_policy,
      'session_state': instance.session_state,
      'scope': instance.scope,
    };
