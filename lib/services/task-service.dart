import 'dart:io';

import 'package:kiwi_mobile/model/dto/task-dto.dart';
import 'package:kiwi_mobile/model/task.dart';

import 'http-service.dart';

class TaskService {
  final httpService = HttpService();

  Future<List<Task>> getListOfTasks() async {
    var response = await httpService.get('/task');
    TaskDto? taskDto = TaskDto.fromJson(response.data);
    return taskDto.data;
  }
}
