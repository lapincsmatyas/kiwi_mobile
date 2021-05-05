import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi_mobile/model/consultation.dart';
import 'package:kiwi_mobile/model/task.dart';

class ConsultationCreationForm extends StatefulWidget {
  Consultation consultation;
  Task? task;
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
    return Container(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Taszk kód"),
              TextFormField(
                initialValue: widget.consultation.taskDTO?.code,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Töltsd ki a mezőt!";
                  }
                },
                enabled: false,
              ),
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
                      widget.onSubmitted(widget.consultation);
                    }
                  },
                  child: Text("Küldés"))
            ],
          ),
        ));
  }
}
