import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi_mobile/model/consultation-list.dart';
import 'package:kiwi_mobile/model/consultation.dart';
import 'package:kiwi_mobile/model/task-list.dart';
import 'package:kiwi_mobile/pages/consultation_creation/consultation_creation_page.dart';
import 'package:kiwi_mobile/pages/task_details_page/consultation_list_component.dart';
import 'package:kiwi_mobile/services/consultation-service.dart';
import 'package:provider/provider.dart';

class ConsultationListPage extends StatefulWidget {
  final String? jwt;

  ConsultationListPage(this.jwt);

  @override
  _ConsultationListPageState createState() => _ConsultationListPageState();
}

class _ConsultationListPageState extends State<ConsultationListPage> {
  final _consultationService = ConsultationService();

  ConsultationList consultationList = new ConsultationList();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _consultationService.getListOfConsultations(widget.jwt),
        builder: (context, AsyncSnapshot<List<Consultation>?> snapshot) {
          return ChangeNotifierProvider<ConsultationList>.value(
            value: consultationList,
            child: Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white,
                title: Text("Rögzített óráim",
                    style: TextStyle(color: Colors.white)),
              ),
              body: Builder(builder: (context) {
                if (snapshot.connectionState == ConnectionState.done) {
                  consultationList.setConsultations(snapshot.data);
                  return ConsultationListComponent(widget.jwt);
                } else {
                  return CircularProgressIndicator();
                }
              }),
              floatingActionButton: FloatingActionButton(
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.lightGreen,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    var taskList = context.read<TaskList>();
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
                                        taskList.tasks, widget.jwt, new Consultation()))));
                  }),
            ),
          );
        });
  }
}
