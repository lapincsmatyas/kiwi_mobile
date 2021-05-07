import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kiwi_mobile/model/task.dart';

part 'task-list.g.dart';

@JsonSerializable()
class TaskList extends ChangeNotifier{
  List<Task> tasks = [];

  TaskList({List<Task>? tasks}){
    if(tasks != null){
      this.tasks = tasks;
    } else {
      this.tasks = [];
    }
  }

  void setTasks(List<Task>? taskList){
    if(taskList != null){
      tasks = taskList;
    } else {
      tasks = [];
    }
  }

  void add(Task task){
    this.tasks.add(task);
    notifyListeners();
  }

  void remove(Task task){
    this.tasks.remove(task);
    notifyListeners();
  }

  void removeById(String id){
    this.tasks.removeWhere((element) => element.id == id);
  }

  dynamic toJson() => _$TaskListToJson(this);
  factory TaskList.fromJson(Map<String, dynamic> obj) => _$TaskListFromJson(obj);
}