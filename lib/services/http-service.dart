import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:kiwi_mobile/services/login-service.dart';

class HttpService {
  final LoginService loginService = LoginService();
  late Dio _dio;

  final baseUrl = "http://10.0.2.2:10080/rest";

  HttpService(){
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
    ));

    initializeInterceptors();
  }

  void initializeInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        log(error.message);
        return handler.next(error);
      },
      onRequest: (options, handler) {
        log("${options.method} ${options.path}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        log(response.data);
        return handler.next(response);
      }
    ));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async{
        String jwt = await loginService.getJwt() ?? "";
        options.headers["Authorization"] = "Bearer " + jwt;
      }
    ));
  }

  Future<Response> getRequest(String endPoint) async {
    Response response;
    try {
      response = await _dio.get(endPoint);
    } on DioError catch (e){
      log(e.message);
      throw Exception(e.message);
    }

    return response;
  }
}