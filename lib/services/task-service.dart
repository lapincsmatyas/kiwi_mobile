import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kiwi_mobile/model/dto/task-dto.dart';


class TaskService {
  var REST_API_IP = 'http://10.0.2.2:10080/rest';

  var _dio = Dio();

  Future<TaskDto?> getListOfTasks(String? jwt) async {
    _dio.options.headers[HttpHeaders.authorizationHeader] = "Bearer $jwt";
    var response = await _dio.get('$REST_API_IP/task');
    return TaskDto.fromJson(response.data);
  }
}
