import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi_mobile/model/task-list.dart';
import 'package:kiwi_mobile/pages/list_page/task_list_component.dart';
import 'package:kiwi_mobile/services/login-service.dart';
import 'package:kiwi_mobile/services/task-service.dart';
import 'package:provider/provider.dart';
import 'package:kiwi_mobile/model/task.dart';

import '../login_page.dart';

class ListPage extends StatefulWidget {
  final String? _jwt;

  ListPage(this._jwt);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final _taskService = TaskService();
  final _loginService = LoginService();

  Future<List<Task>?> getListOfTasks() async {
    return _taskService.getListOfTasks(widget._jwt);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getListOfTasks(),
        builder: (context, AsyncSnapshot<List<Task>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ChangeNotifierProvider(
                create: (context) => TaskList(tasks: snapshot.data),
                child: Scaffold(
                    appBar: AppBar(
                      title: Text("Elérhető projektek"),
                      actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.logout),
                            color: Colors.white,
                            onPressed: () {
                              _loginService.logout();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                  (r) => false);
                            })
                      ],
                    ),
                    body: TaskListComponent(widget._jwt)));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
