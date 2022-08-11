import 'package:intl/intl.dart';

class ScheduleModel {
  ScheduleModel({
    required this.success,
    required this.data,
    required this.msg,
    required this.errors,
  });
  late final bool success;
  late final List<Data> data;
  late final String msg;
  late final List<dynamic> errors;

  get maxDate =>
      data.reduce((a, b) => a.convertedDate!.isAfter(b.convertedDate!) ? a : b);

  get minDate =>
      data.reduce((a, b) => a.convertedDate!.isAfter(b.convertedDate!) ? b : a);

  ScheduleModel.withError(String errorMessage) {
    errors = [errorMessage];
  }

  ScheduleModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
    msg = json['msg'];
    errors = List.castFrom<dynamic, dynamic>(json['errors']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['msg'] = msg;
    _data['errors'] = errors;
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.date,
  });
  late final String id;
  late final String name;
  late final String startTime;
  late final String endTime;
  late final String date;
  DateTime? convertedDate;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    date = json['date'];
    convertedDate = DateFormat('dd/MM/yyyy').parse(date);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['name'] = name;
    _data['startTime'] = startTime;
    _data['endTime'] = endTime;
    _data['date'] = date;
    return _data;
  }
}
