import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kiwi_mobile/model/task.dart';

import 'consultation.dart';

part 'consultation-list.g.dart';

@JsonSerializable()
class ConsultationList extends ChangeNotifier{
  List<Consultation> consultations = List.empty();

  ConsultationList({List<Consultation>? consultations}){
    if(consultations != null){
      this.consultations = consultations;
    } else {
      this.consultations = List.empty();
    }
  }

  void setTask(List<Consultation>? consultations){
    if(consultations != null){
      consultations = consultations;
    } else {
      consultations = List.empty();
    }
    notifyListeners();
  }

  void add(Consultation consultation){
    this.consultations.add(consultation);
    notifyListeners();
  }

  void remove(Consultation consultation){
    this.consultations.remove(consultation);
    notifyListeners();
  }

  void removeById(String id){
    this.consultations.removeWhere((element) => element.id == id);
  }

  dynamic toJson() => _$ConsultationListToJson(this);
  factory ConsultationList.fromJson(Map<String, dynamic> obj) => _$ConsultationListFromJson(obj);
}