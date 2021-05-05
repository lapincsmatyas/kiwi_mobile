import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi_mobile/pages/list_page/list_page.dart';
import 'package:kiwi_mobile/services/login-service.dart';

class LoginPage extends StatelessWidget {
  final _loginService = LoginService();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void displayDialog(BuildContext context, String title, String text) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(title: Text(title), content: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Bejelentkezés"),
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _userNameController,
                decoration: InputDecoration(labelText: 'Felhasználónév'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Jelszó"),
              ),
              TextButton(
                  onPressed: () async {

                    var username = _userNameController.text;
                    var password = _passwordController.text;

                    String? jwt =
                        await _loginService.attemptLogin(username, password);
                    if (jwt != null) {
                      storage.write(key: "jwt", value: jwt);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ListPage(jwt)),
                          (r) => false
                      );
                    }
                  },
                  child: Text("Bejelentkezés")),
            ],
          ),
        ));
  }
}
