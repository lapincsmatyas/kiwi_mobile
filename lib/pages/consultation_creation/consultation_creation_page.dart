import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi_mobile/model/consultation-list.dart';
import 'package:kiwi_mobile/model/consultation.dart';
import 'package:kiwi_mobile/model/expense.dart';
import 'package:kiwi_mobile/model/task-list.dart';
import 'package:kiwi_mobile/model/task.dart';
import 'package:kiwi_mobile/pages/consultation_creation/consultation_creation_form.dart';
import 'package:kiwi_mobile/services/consultation-service.dart';
import 'package:kiwi_mobile/services/login-service.dart';
import 'package:provider/provider.dart';


import '../login_page.dart';


class ConsultationCreationPage extends StatelessWidget {
  final _loginService = LoginService();
  final _consultationService = ConsultationService();
  final Task? task;
  Consultation? consultation;
  String? jwt;

  ConsultationCreationPage(this.jwt, {Key? key, Consultation? consultation, this.task}) :  super(key: key) {
   if(consultation == null){
     this.consultation = new Consultation(
         id: "1",
         startDate: DateTime.now().millisecondsSinceEpoch,
         duration: 60,
         allDay: false,
         description: "",
         taskDTO: this.task,
         expensesDTO: List.filled(1, new Expense()));
   } else {
     this.consultation = consultation;
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.consultation != null ? "Konzultáció szerkesztése" : "Konzultáció rögzítése"),
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
        body: ConsultationCreationForm(
            consultation!,
          onSubmitted: (Consultation consultation) async {
            try {
              Consultation? result = await this._consultationService.createConsultation(jwt, consultation);
              if(result != null) {
                var consultationList = context.read<ConsultationList>();
                consultationList.add(result);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Sikeres rögzítés!")));
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Nem sikerült a konzultáció létrehozása!")));
              }
            } catch (err) {
              log(err.toString());
            }
          }

        )
    );
  }
}
