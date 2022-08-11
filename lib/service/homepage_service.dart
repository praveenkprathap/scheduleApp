import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jobsample/model/schedule_model.dart';
import 'package:jobsample/model/scheduleresponse_model.dart';
import 'package:jobsample/service/api.dart';

class HomepageService extends API {
  Future<ScheduleModel> fetchScheduleList() async {
    try {
      Response response = await getDioInstance().get(url);
      return ScheduleModel.fromJson(response.data);
    } catch (error, stacktrace) {
      // print("Exception occured: $error stackTrace: $stacktrace");
      return ScheduleModel.withError("Data not found / Connection issue");
    }
  }

  Future<ScheduleResponseModel> saveSchedule(
      Map<String, dynamic> params) async {
    try {
      Response response = await getDioInstance().post(
        saveUrl,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: json.encode(params),
      );
      return ScheduleResponseModel.fromJson(response.data);
    } catch (error, stacktrace) {
      // print("Exception occured: $error stackTrace: $stacktrace");
      return ScheduleResponseModel.withError(
          "Data could not be saved / Connection issue");
    }
  }
}
