import 'package:flutter/material.dart';
import 'package:kiwi_mobile/model/consultation-list.dart';
import 'package:kiwi_mobile/model/consultation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

class CalendarViewComponent extends StatefulWidget {
  const CalendarViewComponent();

  @override
  _CalendarViewComponentState createState() => _CalendarViewComponentState();
}

class _CalendarViewComponentState extends State<CalendarViewComponent> {
  List<Consultation> consultations = [];

  @override
  Widget build(BuildContext context) {
    setState(() {
      consultations = context.read<ConsultationList>().consultations;
    });
    return TableCalendar(
        focusedDay: DateTime.now(),
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
      eventLoader: getEventsForDay,
    );
  }

  List<String> getEventsForDay(DateTime day) {
    // Implementation example
    return consultations.where((element) => DateTime.fromMillisecondsSinceEpoch(element.startDate).day == day.day) .map((e) => e.description ?? "-").toList();
  }
}
