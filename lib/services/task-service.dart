import 'dart:io';

import 'package:kiwi_mobile/model/dto/task-dto.dart';
import 'package:kiwi_mobile/model/task.dart';

import 'http-service.dart';

class TaskService {
  final httpService = HttpService();

  Future<List<Task>> getListOfTasks(String? jwt) async {
    var response = await httpService.getRequest('/task');
    TaskDto? taskDto = TaskDto.fromJson(response.data);
    return taskDto.data;
  }
}
