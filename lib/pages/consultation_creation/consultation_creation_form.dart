import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi_mobile/model/consultation.dart';
import 'package:kiwi_mobile/model/task-list.dart';
import 'package:kiwi_mobile/model/task.dart';
import 'package:provider/provider.dart';

class ConsultationCreationForm extends StatefulWidget {
  Consultation consultation;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Function(Consultation consultation) onSubmitted;

  ConsultationCreationForm(this.consultation, {required this.onSubmitted}) {
    selectedDate =
        DateTime.fromMillisecondsSinceEpoch(this.consultation.startDate!);
    selectedTime =
        TimeOfDay(hour: selectedDate!.hour, minute: selectedDate!.minute);
  }

  @override
  _ConsultationCreationFormState createState() =>
      _ConsultationCreationFormState();
}

class _ConsultationCreationFormState extends State<ConsultationCreationForm> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final _formKey = GlobalKey<FormState>();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.selectedDate!,
        firstDate: DateTime(2019, 1),
        lastDate: DateTime(2025));
    if (picked != null) {
      setState(() {
        widget.selectedDate = picked;
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: widget.selectedTime!,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        widget.selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TaskList taskList = context.watch<TaskList>();

    return Container(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Taszk kód"),
              Row(children: [
                Expanded(
                    child: DropdownButtonFormField<Task>(
                        isExpanded: true,
                        value: widget.consultation.taskDTO,
                        validator: (value) {
                          if (value == null) {
                            return 'Válassz taszkot!';
                          }
                          return null;
                        },
                        items: taskList.tasks
                            .map((task) => new DropdownMenuItem<Task>(
                                value: task,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text(task.code!)])))
                            .toList(),
                        onChanged: (value) => {
                              setState(() {
                                widget.consultation.taskDTO = value;
                              })
                            }))
              ]),
              Text("Kezdés"),
              Row(
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: Text(
                              "${widget.selectedDate!.year}.${widget.selectedDate!.month.toString().padLeft(2, '0')}.${widget.selectedDate!.day.toString().padLeft(2, '0')}")),
                    ],
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                          onPressed: () => _selectTime(context),
                          child: Text(
                              "${widget.selectedTime!.hour.toString().padLeft(2, '0')}:${widget.selectedTime!.minute.toString().padLeft(2, '0')}"))
                    ],
                  ),
                ],
              ),
              Text("Hossz"),
              DropdownButton<int>(
                value: widget.consultation.duration,
                items: List<DropdownMenuItem<int>>.generate(
                    100,
                    (int index) => DropdownMenuItem<int>(
                        value: ((index + 1) * 15),
                        child:
                            Text("${((index + 1) * 15 / 60).toString()} óra"))),
                onChanged: (value) {
                  setState(() {
                    widget.consultation.duration = value;
                  });
                },
              ),
              Text("Egész nap"),
              Switch(
                  value: (widget.consultation.allDay)!,
                  onChanged: (value) {
                    setState(() {
                      widget.consultation.allDay = value;
                    });
                  }),
              Text("Leírás"),
              TextFormField(
                initialValue: widget.consultation.description,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (value) {
                  setState(() {
                    widget.consultation.description = value;
                  });
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      var selectedDate = widget.selectedDate;
                      var selectedTime = widget.selectedTime;
                      DateTime date;
                      if (selectedDate != null && selectedTime != null) {
                        date = new DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute);
                      } else {
                        date = DateTime.now();
                      }
                      Consultation consultation = widget.consultation;
                      consultation.startDate = date.millisecondsSinceEpoch;
                      widget.onSubmitted(widget.consultation);
                    }
                  },
                  child: Text("Küldés"))
            ],
          ),
        ));
  }
}
