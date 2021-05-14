import 'dart:developer';
import 'dart:io';

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
      onRequest: (options, handler) async {
        String accessToken = await loginService.getAccessToken() ?? "";
        options.headers[HttpHeaders.authorizationHeader] = "Bearer " + accessToken;
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      }
    ));
  }

  Future<Response> get(String endPoint) async {
    Response response;
    try {
      response = await _dio.get(endPoint);
    } on DioError catch (e){
      throw Exception(e.message.toString());
    }

    return response;
  }

  Future<Response> put(String endPoint, {data}) async {
    Response response;
    try {
      response = await _dio.put(endPoint, data: data);
    } on DioError catch (e){
      throw Exception(e.message.toString());
    }

    return response;
  }

  Future<Response> post(String endPoint, {data}) async {
    Response response;
    try {
      response = await _dio.post(endPoint, data: data);
    } on DioError catch (e){
      throw Exception(e.message.toString());
    }

    return response;
  }

  Future<Response> delete(String endPoint) async {
    Response response;
    try {
      response = await _dio.delete(endPoint);
    } on DioError catch (e){
      throw Exception(e.message.toString());
    }

    return response;
  }
}