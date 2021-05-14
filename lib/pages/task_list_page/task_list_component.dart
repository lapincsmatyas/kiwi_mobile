import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi_mobile/model/task-list.dart';
import 'package:kiwi_mobile/model/task.dart';
import 'package:provider/provider.dart';

import '../task_details_page/task_details_page.dart';

class TaskListComponent extends StatefulWidget {
  TaskListComponent();

  @override
  _TaskListComponentState createState() => _TaskListComponentState();
}

class _TaskListComponentState extends State<TaskListComponent> {
  String filter = "";

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          collapsedHeight: kToolbarHeight + 12,
          automaticallyImplyLeading: false,
          floating: true,
          flexibleSpace: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white.withOpacity(0.3),
            ),
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  style: TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      this.filter = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            context.read<TaskList>().tasks.where((element) => element.code.toLowerCase().contains(filter.toLowerCase())).map((e) => TaskListItem(e)).toList()
          )
        ),
      ],
    );
  }
}

class TaskListItem extends StatelessWidget {
  final Task task;

  const TaskListItem(this.task);

  @override
  Widget build(BuildContext context) {

    return Card(
      child: ListTile(
        title: TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChangeNotifierProvider<TaskList>.value(
                              value: context.read<TaskList>(),
                              child: TaskDetailsPage(task))));
            },
            child: Container(alignment: Alignment.centerLeft, child: Text(task.code))),
      ),
    );
  }
}
