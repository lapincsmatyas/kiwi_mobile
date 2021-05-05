import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi_mobile/model/consultation-list.dart';
import 'package:kiwi_mobile/model/consultation.dart';
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
              childCount: context
                  .select<ConsultationList, int>((consultationList) => consultationList.consultations.length)),
        ),
      ],
    );
  }
}

class ConsultationListItem extends StatelessWidget {
  int index;
  String? jwt;

  ConsultationListItem(this.jwt, this.index);

  @override
  Widget build(BuildContext context) {
    var consultation =
    context.select<ConsultationList, Consultation>((consultationList) => consultationList.consultations[index]);

    return Dismissible(
        key: Key(consultation.id!.toString()),
        onDismissed: (direction) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("$consultation dismissed")));
        },
        background: Container(color: Colors.red),
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
                  Container(
                    child: Text(consultation.description!,
                        style: DefaultTextStyle.of(context).style),
                  )
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
