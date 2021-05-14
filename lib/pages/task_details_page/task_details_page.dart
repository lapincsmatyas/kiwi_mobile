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

class TaskDetailsPage extends StatefulWidget {
  final Task task;

  TaskDetailsPage(this.task);

  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  final _consultationService = ConsultationService();
  late Future<List<Consultation>?> _consultationList;

  @override
  void initState() {
    super.initState();

    _consultationList = _consultationService.getListOfConsultations(task: widget.task);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _consultationList,
        builder: (context, AsyncSnapshot<List<Consultation>?> snapshot) {
          if (snapshot.hasError) {
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
                      title: Text(widget.task.code,
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
                              widget.task.code,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Task leírása",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(widget.task.description!),
                            SizedBox(height: 10),
                            Text(
                              "Taszk státusza",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(widget.task.taskStatus!),
                            SizedBox(height: 10),
                            Text(
                              "Taszk típusa",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(widget.task.taskType!),
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
                                        child: ConsultationListComponent()));
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
                                      new Consultation(taskDTO: widget.task))),
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
