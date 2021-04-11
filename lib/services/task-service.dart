import 'package:dio/dio.dart';


class TaskService {
  var REST_API_IP = 'http://192.168.0.18:10080/rest/task';

  var _dio = Dio();

  Future<String?> getListOfTasks(String jwt) async {
    var response = await _dio.get('$REST_API_IP');
    response.headers.add("Authentication", "Bearer $jwt");
    return response.data;
  }
}
