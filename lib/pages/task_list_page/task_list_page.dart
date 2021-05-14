import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi_mobile/model/task-list.dart';
import 'package:kiwi_mobile/pages/consultation_creation/consultation_creation_page.dart';
import 'package:kiwi_mobile/pages/consultation_list_page/consultation_list_page.dart';
import 'package:kiwi_mobile/pages/task_list_page/task_list_component.dart';
import 'package:kiwi_mobile/services/login-service.dart';
import 'package:kiwi_mobile/services/task-service.dart';
import 'package:provider/provider.dart';
import 'package:kiwi_mobile/model/task.dart';

import '../login_page.dart';

class TaskListPage extends StatefulWidget {
  TaskListPage();

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final _taskService = TaskService();
  final _loginService = LoginService();

  late Future<List<Task>?> _taskList;

  @override
  void initState() {
    super.initState();

    _taskList = getListOfTasks();
  }

  Future<List<Task>?> getListOfTasks() async {
    return _taskService.getListOfTasks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _taskList,
        builder: (context, AsyncSnapshot<List<Task>?> snapshot) {
          return ChangeNotifierProvider<TaskList>(
              create: (context) => TaskList(),
              child: Scaffold(
                  appBar: AppBar(
                    title: Text("Elérhető projektek",
                        style: TextStyle(color: Colors.white)),
                  ),
                  drawer: Drawer(
                      child:
                          ListView(padding: EdgeInsets.zero, children: <Widget>[
                    DrawerHeader(
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Image.asset('assets/kiwi_logo.png')),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.list,
                              color: Theme.of(context).primaryColor),
                          SizedBox(width: 10),
                          Text('Elérhető projektek')
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Builder(
                      builder: (context) {
                        return ListTile(
                          title: Row(
                            children: [
                              Icon(Icons.list_alt,
                                  color: Theme.of(context).primaryColor),
                              SizedBox(width: 10),
                              Text('Rögzített óráim')
                            ],
                          ),
                          onTap: () {
                            var taskList = context.read<TaskList>();
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider<TaskList>.value(
                                            value: taskList,
                                            child: ConsultationListPage())));
                          },
                        );
                      }
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.logout,
                              color: Theme.of(context).primaryColor),
                          SizedBox(width: 10),
                          Text('Kijelentkezés')
                        ],
                      ),
                      onTap: () {
                        _loginService.logout();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                            (r) => false);
                      },
                    ),
                  ])),
                  body: Builder(builder: (context) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      context.read<TaskList>().setTasks(snapshot.data);
                      return TaskListComponent();
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  })));
        });
  }
}
