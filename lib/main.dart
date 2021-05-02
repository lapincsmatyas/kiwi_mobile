import 'package:flutter/material.dart';
import 'package:kiwi_mobile/pages/list_page.dart';
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
      home: FutureBuilder(
          future: _loginService.getJwt(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            if (snapshot.data != "") {
              return ListPage(snapshot.data.toString());
            } else {
              return LoginPage();
            }
          }),
    );
  }
}
