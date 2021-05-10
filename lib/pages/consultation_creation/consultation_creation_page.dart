import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi_mobile/model/consultation-list.dart';
import 'package:kiwi_mobile/model/consultation.dart';
import 'package:kiwi_mobile/model/task.dart';
import 'package:kiwi_mobile/pages/consultation_creation/consultation_creation_form.dart';
import 'package:kiwi_mobile/services/consultation-service.dart';
import 'package:kiwi_mobile/services/login-service.dart';
import 'package:provider/provider.dart';

import '../login_page.dart';

class ConsultationCreationPage extends StatelessWidget {
  final _loginService = LoginService();
  final _consultationService = ConsultationService();

  final Consultation consultation;
  final String? jwt;
  final bool create;

  final List<Task> tasks;

  ConsultationCreationPage(this.tasks, this.jwt, this.consultation)
      : create = consultation.id == null ? true : false;

  @override
  Widget build(BuildContext context) {
    ConsultationList consultationList = context.watch<ConsultationList>();

    return Scaffold(
        appBar: AppBar(
          title: Text(this.consultation.id != null
              ? "Konzultáció szerkesztése"
              : "Konzultáció rögzítése"),
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
        body: ConsultationCreationForm(this.tasks, this.consultation,
            onSubmitted: (Consultation consultation) async {
          try {
            Consultation? result = this.create
                ? await this
                    ._consultationService
                    .createConsultation(jwt, consultation)
                : await this
                    ._consultationService
                    .updateConsultation(jwt, consultation);
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
