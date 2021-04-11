import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/jwt.dart';

final storage = FlutterSecureStorage();

class LoginService {
  var _dio = Dio.Dio();

  var _AUTH_IP =
      'http://10.0.2.2:8080/auth/realms/kiwi/protocol/openid-connect/token';

  Future<String?> getJwt() async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  Future<String?> attemptLogin(String username, String password) async {
    Map<String, String> body = {
      "client_id": "kiwi-rest-client",
      "grant_type": "password",
      "client_secret": "",
      "scope": "openid",
      "username": username,
      "password": password
    };
    var response = await _dio.post('$_AUTH_IP',
        data: body,
        options: Dio.Options(contentType: Dio.Headers.formUrlEncodedContentType)
    );

    if (response.statusCode == 200) {
      JWT deserialized = JWT.fromJson(response.data);
      return deserialized.access_token;
    }

    return null;
  }

  void logout(){
    storage.delete(key: "jwt");
  }
}