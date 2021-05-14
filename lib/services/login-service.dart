import 'dart:convert';

import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/jwt.dart';

final storage = FlutterSecureStorage();

class LoginService {
  bool loggedIn = false;

  var _dio = Dio.Dio();

  var _AUTH_IP =
      'http://10.0.2.2:8080/auth/realms/kiwi/protocol/openid-connect/token';

  Future<String?> getAccessToken() async {
    return await storage.read(key: "access_token");
  }

  Future<String?> getRefreshToken() async{
    return await storage.read(key: "refresh_token");
  }

  Future<JWT?> attemptLogin(String username, String password) async {
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
        options:
            Dio.Options(contentType: Dio.Headers.formUrlEncodedContentType));

    if (response.statusCode == 200) {
      JWT jwt = JWT.fromJson(response.data);
      storage.write(key: "access_token", value: jwt.access_token);
      storage.write(key: "refresh_token", value: jwt.refresh_token);
      this.loggedIn = true;
      return JWT.fromJson(response.data);
    } else {
      this.loggedIn = false;
      return null;
    }
  }

  void logout() {
    storage.delete(key: "access_token");
    storage.delete(key: "refresh_token");
    this.loggedIn = false;
  }

  isLoggedIn() {
    return this.loggedIn;
  }
}
