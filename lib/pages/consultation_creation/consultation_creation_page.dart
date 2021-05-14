import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi_mobile/model/consultation-list.dart';
import 'package:kiwi_mobile/model/consultation.dart';
import 'package:kiwi_mobile/model/task.dart';
import 'package:kiwi_mobile/pages/consultation_creation/consultation_creation_form.dart';
import 'package:kiwi_mobile/services/consultation-service.dart';
import 'package:provider/provider.dart';

class ConsultationCreationPage extends StatelessWidget {
  final _consultationService = ConsultationService();

  final Consultation consultation;
  final bool create;

  final List<Task> tasks;

  ConsultationCreationPage(this.tasks, this.consultation)
      : create = consultation.id == null ? true : false;

  @override
  Widget build(BuildContext context) {
    ConsultationList consultationList = context.watch<ConsultationList>();

    return Scaffold(
        appBar: AppBar(
          title: Text(this.consultation.id != null
              ? "Konzultáció szerkesztése"
              : "Konzultáció rögzítése", style: TextStyle(color: Colors.white),)
        ),
        body: ConsultationCreationForm(this.tasks, this.consultation,
            onSubmitted: (Consultation consultation) async {
          try {
            Consultation? result = this.create
                ? await this
                    ._consultationService
                    .createConsultation(consultation)
                : await this
                    ._consultationService
                    .updateConsultation(consultation);
            if (result == null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Hiba történt!")));
            } else {
              if (this.create) {
                consultationList.add(result);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Sikeres rögzítés!")));
              } else {
                consultationList.update(result);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Sikeres módosítás!")));
              }
            }
            Navigator.pop(context);
          } catch (err) {
            log(err.toString());
          }
        }));
  }
}
