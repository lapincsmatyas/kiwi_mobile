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

import 'calendar_view_page.dart';

enum ViewMode { CALENDAR, LIST, TABLE }

class ConsultationListPage extends StatefulWidget {
  ConsultationListPage();

  @override
  _ConsultationListPageState createState() => _ConsultationListPageState();
}

class _ConsultationListPageState extends State<ConsultationListPage> {
  ViewMode viewMode = ViewMode.LIST;

  final _consultationService = ConsultationService();
  late Future<List<Consultation>?> _consultationList;

  @override
  void initState() {
    super.initState();
    _consultationList = _consultationService.getListOfConsultations();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _consultationList,
        builder: (context, AsyncSnapshot<List<Consultation>?> snapshot) {
          return ChangeNotifierProvider<ConsultationList>(
            create: (context) => ConsultationList(),
            child: Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.white,
                title: Text("Rögzített óráim",
                    style: TextStyle(color: Colors.white)),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(
                          viewMode == ViewMode.CALENDAR
                              ? Icons.list
                              : Icons.calendar_today,
                          color: Colors.white),
                      onPressed: () {
                        setState(() {
                          viewMode = viewMode == ViewMode.CALENDAR
                              ? ViewMode.LIST
                              : ViewMode.CALENDAR;
                        });
                      })
                ],
              ),
              body: Builder(builder: (context) {
                if (snapshot.connectionState == ConnectionState.done) {
                  context
                      .read<ConsultationList>()
                      .setConsultations(snapshot.data);
                  switch (viewMode) {
                    case ViewMode.CALENDAR:
                      return CalendarViewComponent();
                    case ViewMode.LIST:
                      return ConsultationListComponent();
                    case ViewMode.TABLE:
                      return Text("WIP");
                  }
                } else {
                  return CircularProgressIndicator();
                }
              }),
              floatingActionButton: Builder(
                builder: (context) {
                  return FloatingActionButton(
                      child: const Icon(Icons.add),
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.white,
                      onPressed: () {
                        var taskList = context.read<TaskList>();
                        var consultationList = context.read<ConsultationList>();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MultiProvider(
                                        providers: [
                                          ChangeNotifierProvider<
                                                  ConsultationList>.value(
                                              value: consultationList),
                                          ChangeNotifierProvider<TaskList>.value(
                                              value: taskList)
                                        ],
                                        child: ConsultationCreationPage(
                                            taskList.tasks, new Consultation()))));
                      });
                }
              ),
            ),
          );
        });
  }
}
