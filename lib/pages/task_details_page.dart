import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi_mobile/model/consultation.dart';
import 'package:kiwi_mobile/model/dto/consultation-dto.dart';
import 'package:kiwi_mobile/model/jwt.dart';
import 'package:kiwi_mobile/model/task.dart';
import 'package:kiwi_mobile/pages/consultation-creation/consultation_creation_form.dart';
import 'package:kiwi_mobile/services/consultation-service.dart';
import 'package:kiwi_mobile/services/login-service.dart';

import 'consultation-creation/consultation_creation_page.dart';
import 'login_page.dart';

class TaskDetailsPage extends StatelessWidget {
  final _loginService = LoginService();
  final _consultationService = ConsultationService();

  final Task task;
  final String? jwt;

  TaskDetailsPage(this.jwt, this.task);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.code!),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              color: Colors.white,
              onPressed: () {
                _loginService.logout();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (r) => false);
              })
        ],
      ),
      body: Container(
        padding: new EdgeInsets.all(10.0),
        child: Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Taszk kódja",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          Text(
            task.code!,
          ),
          SizedBox(height: 10),
          Text(
            "Task leírása",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          Text(task.description!),
          SizedBox(height: 10),
          Text(
            "Taszk státusza",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          Text(task.taskStatus!),
          SizedBox(height: 10),
          Text(
            "Taszk típusa",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          Text(task.taskType!),
          SizedBox(height: 20),
          Text(
            "Konzultációk",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          FutureBuilder(
              future:
                  _consultationService.getListOfConsultations(jwt, task: task),
              builder: (context, AsyncSnapshot<List<Consultation>?> snapshot) {
                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return Text(snapshot.error.toString());
                }
                return Column(children: [
                  Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var item = snapshot.data![index];
                        return Dismissible(
                            key: Key(item.id!.toString()),
                            onDismissed: (direction) {
                              // Then show a snackbar.
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("$item dismissed")));
                            },
                            background: Container(color: Colors.red),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ConsultationCreationPage(jwt,
                                                consultation: item)));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        child: Text(item.description!,
                                            style: DefaultTextStyle.of(context)
                                                .style),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        child: Text(
                                            new DateTime.fromMillisecondsSinceEpoch(
                                                    item.startDate!)
                                                .toString(),
                                            style: DefaultTextStyle.of(context)
                                                .style),
                                      ),
                                      Container(
                                        child: Text(
                                            "Hossz: ${(item.duration! / 60).toString()} óra",
                                            style: DefaultTextStyle.of(context)
                                                .style),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ));
                      },
                    ),
                  )
                ]);
              })
        ])),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ConsultationCreationPage(jwt, task: task)));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
      ),
    );
  }
}
