import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi_mobile/model/dto/task-dto.dart';
import 'package:kiwi_mobile/services/login-service.dart';
import 'package:kiwi_mobile/services/task-service.dart';

import 'login_page.dart';


class ListPage extends StatelessWidget {
  final _taskService = TaskService();
  final _loginService = LoginService();

  final _jwt;

  ListPage(this._jwt);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Elérhető projektek"), actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              color: Colors.white,
              onPressed: () {
                _loginService.logout();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (r) => false
                );
              }
          )
        ],),
        body: Center(
            child: FutureBuilder(
                future: _taskService.getListOfTasks(_jwt),
                builder: (context, AsyncSnapshot<TaskDto?> snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if(snapshot.data != null && snapshot.data!.data.length > 0){
                    return ListView(
                      children: [
                        for(var task in snapshot.data!.data) Text(task.code!)
                      ],
                    );
                  }

                  return Text(snapshot.data.toString());
                }
            )));
  }
}
