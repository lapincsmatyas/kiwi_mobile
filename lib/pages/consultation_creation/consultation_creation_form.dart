import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiwi_mobile/model/consultation.dart';
import 'package:kiwi_mobile/model/task.dart';

class ConsultationCreationForm extends StatefulWidget {
  Consultation consultation;
  DateTime selectedDate;
  TimeOfDay selectedTime;
  Function(Consultation consultation) onSubmitted;
  List<Task> tasks;

  ConsultationCreationForm(this.tasks, this.consultation,
      {required this.onSubmitted})
      : selectedDate =
            DateTime.fromMillisecondsSinceEpoch(consultation.startDate),
        selectedTime = TimeOfDay(
            hour: DateTime.fromMillisecondsSinceEpoch(consultation.startDate)
                .hour,
            minute: DateTime.fromMillisecondsSinceEpoch(consultation.startDate)
                .minute);

  @override
  _ConsultationCreationFormState createState() =>
      _ConsultationCreationFormState();
}

class _ConsultationCreationFormState extends State<ConsultationCreationForm> {
  final _formKey = GlobalKey<FormState>();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.selectedDate,
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
      initialTime: widget.selectedTime,
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //Taszk kód
              Row(children: [
                SizedBox(width: 50,),
                Expanded(
                    child: DropdownButtonHideUnderline(
                  child: DropdownButton<Task>(
                      isExpanded: true,
                      value: widget.consultation.taskDTO,
                      items: widget.tasks
                          .map((task) => new DropdownMenuItem<Task>(
                              value: task,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text(task.code)])))
                          .toList(),
                      onChanged: (value) => {
                            setState(() {
                              widget.consultation.taskDTO = value;
                            })
                          }),
                ))
              ]),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 13, right: 10),
                        child: SizedBox(
                          width: 40,
                          child: Icon(Icons.access_time),
                        ),
                      )
                    ],
                  ),
                  //All day
                  Expanded(
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [Text("Egész nap")],
                          ),
                          Column(
                            children: [
                              Switch(
                                  value: (widget.consultation.allDay),
                                  onChanged: (value) {
                                    setState(() {
                                      widget.consultation.allDay = value;
                                    });
                                  }),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              TextButton(
                                onPressed: () => _selectDate(context),
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero),
                                child: Text(
                                    "${widget.selectedDate.year}.${widget.selectedDate.month.toString().padLeft(2, '0')}.${widget.selectedDate.day.toString().padLeft(2, '0')}",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor)),
                              )
                            ],
                          ),
                          Builder(builder: (context) {
                            if (!widget.consultation.allDay) {
                              return Column(
                                children: [
                                  TextButton(
                                      onPressed: () => _selectTime(context),
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero),
                                      child: Text(
                                          "${widget.selectedTime.hour.toString().padLeft(2, '0')}:${widget.selectedTime.minute.toString().padLeft(2, '0')}"))
                                ],
                              );
                            } else
                              return Container();
                          })
                        ],
                      )
                    ]),
                  ),

                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 13, right: 10),
                        child: SizedBox(
                          width: 40,
                          child: Icon(Icons.hourglass_bottom),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: widget.consultation.duration,
                          items: List<DropdownMenuItem<int>>.generate(
                              100,
                              (int index) => DropdownMenuItem<int>(
                                  value: ((index + 1) * 15),
                                  child: Text(
                                      "${((index + 1) * 15 / 60).toString()} óra"))),
                          onChanged: (value) {
                            setState(() {
                              widget.consultation.duration = value ?? 60;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 13, right: 10),
                        child: SizedBox(
                          width: 40,
                          child: Icon(Icons.description_outlined),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: "Leírás"
                          ),
                          initialValue: widget.consultation.description,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          onChanged: (value) {
                            setState(() {
                              widget.consultation.description = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 13, right: 10),
                        child: SizedBox(
                          width: 40,
                          child: Icon(Icons.attach_money_outlined),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Költések"
                          ),
                          initialValue:
                              widget.consultation.expensesDTO[0].description,
                          onChanged: (value) {
                            setState(() {
                              widget.consultation.expensesDTO[0].description =
                                  value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            var selectedDate = widget.selectedDate;
                            var selectedTime = widget.selectedTime;
                            DateTime date = new DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute);
                            Consultation consultation = widget.consultation;
                            consultation.startDate = date.millisecondsSinceEpoch;
                            widget.onSubmitted(widget.consultation);
                          }
                        },
                        child: Text("Küldés")),
                  ),
                ],
              )
            ])));
  }
}
