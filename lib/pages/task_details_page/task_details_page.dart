import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi_mobile/model/consultation-list.dart';
import 'package:kiwi_mobile/model/consultation.dart';
import 'package:kiwi_mobile/model/task-list.dart';
import 'package:kiwi_mobile/model/task.dart';
import 'package:kiwi_mobile/services/consultation-service.dart';
import 'package:provider/provider.dart';

import '../consultation_creation/consultation_creation_page.dart';
import 'consultation_list_component.dart';

class TaskDetailsPage extends StatelessWidget {
  final _consultationService = ConsultationService();

  final Task task;
  final String? jwt;

  TaskDetailsPage(this.jwt, this.task);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _consultationService.getListOfConsultations(jwt, task: task),
        builder: (context, AsyncSnapshot<List<Consultation>?> snapshot) {
          if (snapshot.hasError) {
            log(snapshot.error.toString());
            return Text(snapshot.error.toString());
          }
          return ChangeNotifierProvider(
              create: (context) => ConsultationList(consultations: snapshot.data),
              child: Builder(
                builder: (context) {
                  var consultationList = context.watch<ConsultationList>();
                  var taskList = context.read<TaskList>();
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(task.code!,
                          style: TextStyle(color: Colors.white)),
                    ),
                    body: Container(
                      padding: new EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            Builder(builder: (context) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                consultationList.setConsultations(snapshot.data);
                                return Expanded(
                                    child: Container(
                                        height: 200,
                                        child: ConsultationListComponent(jwt)));
                              } else {
                                return CircularProgressIndicator();
                              }
                            })
                          ]),
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider<
                                            ConsultationList>.value(
                                        value: consultationList)
                                  ],
                                  child: ConsultationCreationPage(
                                      taskList.tasks,
                                      jwt,
                                      new Consultation(taskDTO: task))),
                            ));
                      },
                      child: const Icon(Icons.add),
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.white,
                    ),
                  );
                },
              ));
        });
  }
}
