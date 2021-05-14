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
  final bool taskSpecific;
  ConsultationListComponent({this.taskSpecific = false});

  @override
  _ConsultationListComponentState createState() =>
      _ConsultationListComponentState();
}

class _ConsultationListComponentState extends State<ConsultationListComponent> {
  String filter = "";
  late ConsultationList consultationList;
  late TaskList taskList;

  @override
  Widget build(BuildContext context) {
    setState(() {
      consultationList = context.watch<ConsultationList>();
      taskList = context.read<TaskList>();
    });

    if (consultationList.consultations.isEmpty) {
      return Text("Nincs rögzített konzultáció ehhez a taszkhoz");
    }

    return CustomScrollView(
      slivers: [
       if(!widget.taskSpecific) SliverAppBar(
          collapsedHeight: kToolbarHeight + 12,
          automaticallyImplyLeading: false,
          floating: true,
          flexibleSpace: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white.withOpacity(0.3),
            ),
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  style: TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                    hintText: "Taszk neve",
                    hintStyle: TextStyle(color: Colors.black12.withOpacity(0.2)),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      this.filter = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate(consultationList
                .consultations
                .where((element) =>
                    element.taskDTO?.code.toLowerCase().contains(filter.toLowerCase()) ?? false)
                .map((e) => ConsultationListItem(e, onPressed: (consultation) {
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
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Konzultáció törölve")));
                    }))
                .toList())),
      ],
    );
  }
}

class ConsultationListItem extends StatelessWidget {
  final Consultation consultation;
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
                        consultation.description ?? " - ",
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
                        var day =
                            "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}.";
                        var time =
                            "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
                        return Text(
                            "${day}${consultation.allDay ? "" : " " + time}",
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
