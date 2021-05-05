import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kiwi_mobile/model/consultation.dart';
import 'package:kiwi_mobile/model/dto/consultation-creation-dto.dart';
import 'package:kiwi_mobile/model/dto/consultation-creation-response-dto.dart';
import 'package:kiwi_mobile/model/dto/consultation-dto.dart';
import 'package:kiwi_mobile/model/dto/filter-dto.dart';
import 'package:kiwi_mobile/model/task.dart';

final storage = FlutterSecureStorage();

class ConsultationService {
  var REST_API_IP = 'http://10.0.2.2:10080/rest';

  var _dio = Dio.Dio();

  Future<List<Consultation>?> getListOfConsultations(String? jwt,
      {Task? task = null}) async {
    _dio.options.headers[HttpHeaders.authorizationHeader] = "Bearer $jwt";
    var orderParams = new Map<String, String>();
    orderParams["startDate"] = "ASC";
    FilterDto filter = new FilterDto(task?.id, 1, 10, null, null, orderParams);
    var response = await _dio.post('$REST_API_IP/consultation/filter',
        data: filter.toJson());
    List<Consultation>? consultations =
        ConsultationDto.fromJson(response.data).data;
    return consultations;
  }

  Future<Consultation?> createConsultation(
      String? jwt, Consultation consultation) async {
    _dio.options.headers[HttpHeaders.authorizationHeader] = "Bearer $jwt";
    ConsultationCreationDto consultationCreationDto =
        new ConsultationCreationDto(
            consultation.id,
            consultation.startDate,
            consultation.duration,
            consultation.allDay,
            consultation.description,
            consultation.taskDTO!.id,
            consultation.expensesDTO);

    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    log(encoder.convert(consultationCreationDto.toJson()));

    var response = await _dio.put('$REST_API_IP/consultation',
        data: consultationCreationDto.toJson());
    ConsultationCreationResponseDto consultationCreationResponseDto = ConsultationCreationResponseDto.fromJson(response.data);
    if (consultationCreationResponseDto.successful != null && consultationCreationResponseDto.successful == true){
      return consultation;
    } else {
      return null;
    }
  }
}
