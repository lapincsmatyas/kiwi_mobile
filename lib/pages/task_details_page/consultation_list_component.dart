import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi_mobile/model/consultation-list.dart';
import 'package:kiwi_mobile/model/consultation.dart';
import 'package:kiwi_mobile/model/task-list.dart';
import 'package:kiwi_mobile/services/consultation-service.dart';
import 'package:provider/provider.dart';
import 'package:kiwi_mobile/pages/consultation_creation/consultation_creation_page.dart';

class ConsultationListComponent extends StatefulWidget {
  ConsultationListComponent();

  @override
  _ConsultationListComponentState createState() =>
      _ConsultationListComponentState();
}

class _ConsultationListComponentState extends State<ConsultationListComponent> {
  @override
  Widget build(BuildContext context) {
    var consultationList = context.watch<ConsultationList>();
    var taskList = context.read<TaskList>();

    if (consultationList.consultations.isEmpty) {
      return Text("Nincs rögzített konzultáció ehhez a taszkhoz");
    }

    return ListView.builder(
        itemCount: consultationList.consultations.length,
        itemBuilder: (context, index) {
          return ConsultationListItem(consultationList.consultations[index],
              onPressed: (consultation) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider<ConsultationList>.value(
                          value: consultationList)
                    ],
                    child: ConsultationCreationPage(
                        taskList.tasks, consultation)),
              ),
            );
          }, onDismissed: (direction, consultation) {
            consultationList.removeById(consultation.id!);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Konzultáció törölve")));
          });
        });
  }
}

class ConsultationListItem extends StatelessWidget {
  Consultation consultation;
  String? jwt;
  final _consultationService = ConsultationService();

  Function(Consultation consultation) onPressed;
  Function(DismissDirection direction, Consultation consultation) onDismissed;

  ConsultationListItem(this.consultation,
      {required this.onPressed, required this.onDismissed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Dismissible(
          key: Key(consultation.id!.toString()),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            var result = await this
                ._consultationService
                .deleteConsultation(consultation);
            if (result == null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Sikertelen törlés")));
            }
            return Future.value(result != null);
          },
          onDismissed: (direction) async {
            this.onDismissed(direction, consultation);
          },
          background: Container(
            color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: AlignmentDirectional.centerEnd,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: TextButton(
            onPressed: () {
              this.onPressed(consultation);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      child: Text(
                        consultation.description ??
                            " - ",
                        style: TextStyle(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: Builder(builder: (context) {
                        var date = DateTime.fromMillisecondsSinceEpoch(
                            consultation.startDate);
                        var day = "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}.";
                        var time = "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
                        return Text("${day}${consultation.allDay ? "" : " " + time}",
                            style: DefaultTextStyle.of(context).style);
                      }),
                    ),
                    Container(
                      child: Text(
                          "Hossz: ${(consultation.duration / 60).toString()} óra",
                          style: DefaultTextStyle.of(context).style),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
