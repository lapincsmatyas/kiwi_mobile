import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi_mobile/model/jwt.dart';
import 'package:kiwi_mobile/model/task-list.dart';
import 'package:kiwi_mobile/model/task.dart';
import 'package:kiwi_mobile/services/task-service.dart';
import 'package:provider/provider.dart';

import '../task_details_page/task_details_page.dart';

class TaskListComponent extends StatelessWidget {
  final String? _jwt;

  TaskListComponent(this._jwt) {}

  final _taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => TaskListItem(_jwt, index),
              childCount: context
                  .select<TaskList, int>((taskList) => taskList.tasks.length)),
        ),
      ],
    );
  }
}

class TaskListItem extends StatelessWidget {
  final int index;
  final String? _jwt;

  const TaskListItem(this._jwt, this.index);

  @override
  Widget build(BuildContext context) {
    var task =
        context.select<TaskList, Task>((taskList) => taskList.tasks[index]);
    var taskList = context.read<TaskList>();

    return Card(
      child: ListTile(
        title: TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChangeNotifierProvider<TaskList>.value(
                              value: taskList,
                              child: TaskDetailsPage(this._jwt, task))));
            },
            child: Container(alignment: Alignment.centerLeft, child: Text(task.code!))),
      ),
    );
  }
}
