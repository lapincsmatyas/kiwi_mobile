import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import 'consultation.dart';

part 'consultation-list.g.dart';

@JsonSerializable()
class ConsultationList extends ChangeNotifier{
  List<Consultation> consultations = List.empty();

  ConsultationList({List<Consultation>? consultations}){
    if(consultations != null){
      this.consultations = consultations;
    } else {
      this.consultations = [];
    }
  }

  void setConsultations(List<Consultation>? consultations){
    if(consultations != null){
      this.consultations = consultations;
    } else {
      this.consultations = [];
    }
  }

  void add(Consultation consultation){
    this.consultations.add(consultation);
    notifyListeners();
  }

  void remove(Consultation consultation){
    this.consultations.remove(consultation);
    notifyListeners();
  }

  void update(Consultation consultation){
    consultations[consultations.indexWhere((element) => element.id == consultation.id)] = consultation;
    notifyListeners();
  }

  void removeById(String id){
    this.consultations.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  dynamic toJson() => _$ConsultationListToJson(this);
  factory ConsultationList.fromJson(Map<String, dynamic> obj) => _$ConsultationListFromJson(obj);
}