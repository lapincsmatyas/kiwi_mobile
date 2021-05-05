import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi_mobile/model/consultation-list.dart';
import 'package:kiwi_mobile/model/consultation.dart';
import 'package:kiwi_mobile/services/consultation-service.dart';
import 'package:provider/provider.dart';
import 'package:kiwi_mobile/pages/consultation_creation/consultation_creation_page.dart';

class ConsultationListComponent extends StatelessWidget {
  String? jwt;

  ConsultationListComponent(this.jwt);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => ConsultationListItem(jwt, index),
              childCount: context.select<ConsultationList, int>(
                  (consultationList) => consultationList.consultations.length)),
        ),
      ],
    );
  }
}

class ConsultationListItem extends StatelessWidget {
  int index;
  String? jwt;
  final _consultationService = ConsultationService();

  ConsultationListItem(this.jwt, this.index);

  @override
  Widget build(BuildContext context) {
    var consultation = context.select<ConsultationList, Consultation>(
        (consultationList) => consultationList.consultations[index]);

    return Dismissible(
        key: Key(consultation.id!.toString()),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          var result = await this
              ._consultationService
              .deleteConsultation(jwt, consultation);
          if(result == null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Sikertelen törlés")));
          }
          return Future.value(result != null);
        },
        onDismissed: (direction) async {
          var consultationList = context.read<ConsultationList>();
          consultationList.removeById(consultation.id!);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Konzultáció törölve")));
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
            var consultationList = context.read<ConsultationList>();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChangeNotifierProvider<ConsultationList>.value(
                          value: consultationList,
                          child: ConsultationCreationPage(jwt,
                              consultation: consultation)),
                ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(consultation.id!.substring(0, 10),
                              style: DefaultTextStyle.of(context).style),
                        ),
                        Container(
                          child: Text(consultation.description!,
                              style: DefaultTextStyle.of(context).style),
                        ),
                      ])
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    child: Text(
                        new DateTime.fromMillisecondsSinceEpoch(
                                consultation.startDate!)
                            .toString(),
                        style: DefaultTextStyle.of(context).style),
                  ),
                  Container(
                    child: Text(
                        "Hossz: ${(consultation.duration! / 60).toString()} óra",
                        style: DefaultTextStyle.of(context).style),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
