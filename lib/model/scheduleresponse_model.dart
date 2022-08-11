class ScheduleResponseModel {
  late bool success;
  Data? data;
  late String msg;
  late List<dynamic> errors;

  ScheduleResponseModel(
      {required this.success,
      required this.data,
      required this.msg,
      required this.errors});

  ScheduleResponseModel.withError(String errorMessage) {
    errors = [errorMessage];
    success = false;
  }
  ScheduleResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    msg = json['msg'];
    errors = [];
    if (json['errors'] != null) {
      json['errors'].forEach((v) {
        errors.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['msg'] = msg;
    if (errors.isNotEmpty) {
      data['errors'] = errors.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? name;
  String? phoneNumber;
  String? startTime;
  String? endTime;
  String? date;
  String? sId;
  int? iV;

  Data(
      {this.name,
      this.phoneNumber,
      this.startTime,
      this.endTime,
      this.date,
      this.sId,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    date = json['date'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['date'] = date;
    data['_id'] = sId;
    data['__v'] = iV;
    return data;
  }
}
