import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kiwi_mobile/model/consultation.dart';
import 'package:kiwi_mobile/model/dto/consultation-creation-dto.dart';
import 'package:kiwi_mobile/model/dto/consultation-creation-response-dto.dart';
import 'package:kiwi_mobile/model/dto/consultation-dto.dart';
import 'package:kiwi_mobile/model/dto/filter-dto.dart';
import 'package:kiwi_mobile/model/task.dart';

import 'http-service.dart';

final storage = FlutterSecureStorage();

class ConsultationService {
  HttpService httpService = HttpService();

  Future<List<Consultation>?> getListOfConsultations({Task? task}) async {
    var orderParams = new Map<String, String>();
    orderParams["startDate"] = "ASC";
    FilterDto filter = new FilterDto(task?.id, 1, 10, null, null, orderParams);
    var response = await this.httpService.post('/consultation/filter', data: filter.toJson());
    List<Consultation>? consultations =
        ConsultationDto.fromJson(response.data).data;
    return consultations;
  }

  Future<Consultation?> createConsultation(Consultation consultation) async {
    ConsultationCreationDto consultationCreationDto =
        new ConsultationCreationDto(
            consultation.id,
            consultation.startDate,
            consultation.duration,
            consultation.allDay,
            consultation.description,
            consultation.taskDTO!.id,
            consultation.expensesDTO);

    var response = await this.httpService.put('/consultation', data: consultationCreationDto.toJson());
    ConsultationCreationResponseDto consultationCreationResponseDto = ConsultationCreationResponseDto.fromJson(response.data);
    if (consultationCreationResponseDto.successful != null && consultationCreationResponseDto.successful == true){
      consultation.id = consultationCreationResponseDto.data;
      return consultation;
    } else {
      return null;
    }
  }

  Future<Consultation?> updateConsultation(Consultation consultation) async {

    ConsultationCreationDto consultationCreationDto =
    new ConsultationCreationDto(
        consultation.id,
        consultation.startDate,
        consultation.duration,
        consultation.allDay,
        consultation.description,
        consultation.taskDTO!.id,
        consultation.expensesDTO);

    var response = await this.httpService.post('/consultation/update', data: consultationCreationDto.toJson());

    ConsultationCreationResponseDto consultationCreationResponseDto = ConsultationCreationResponseDto.fromJson(response.data);
    if (consultationCreationResponseDto.successful != null && consultationCreationResponseDto.successful == true){
      return consultation;
    } else {
      return null;
    }
  }

  Future<String?> deleteConsultation(Consultation consultation) async {
    var response = await this.httpService.delete('/consultation/${consultation.id}');
    ConsultationCreationResponseDto consultationCreationResponseDto = ConsultationCreationResponseDto.fromJson(response.data);
    if (consultationCreationResponseDto.successful != null && consultationCreationResponseDto.successful == true){
      return consultation.id;
    } else {
      return null;
    }
  }
}
