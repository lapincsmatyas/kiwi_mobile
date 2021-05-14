import 'package:flutter/material.dart';
import 'package:kiwi_mobile/pages/task_list_page/task_list_page.dart';
import 'package:kiwi_mobile/services/login-service.dart';

import 'pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _loginService = LoginService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KIWI',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: Builder(
          builder: (context) {
            return _loginService.isLoggedIn() ?  TaskListPage() : LoginPage();
          }),
    );
  }
}
