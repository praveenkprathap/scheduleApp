import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jobsample/model/schedule_model.dart';
import 'package:jobsample/model/scheduleresponse_model.dart' as res;
import 'package:jobsample/service/api.dart';
import 'package:jobsample/service/homepage_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleInitial()) {
    on<GetSchedule>((event, emit) async {
      try {
        emit(ScheduleLoading());
        final sList = await HomepageService().fetchScheduleList();
        ScheduleLoaded newState = ScheduleLoaded(sList);
        newState.selectedDateData = [];
        newState.selctedDate = newState.scheduleModel.minDate.convertedDate;
        for (var e in newState.scheduleModel.data) {
          if (e.convertedDate!
                  .compareTo(newState.scheduleModel.minDate.convertedDate) ==
              0) {
            newState.selectedDateData!.add(e);
          }
        }
        newState.selectedDateData!.sort((a, b) => DateFormat("hh:mm:ss")
            .parse(a.startTime)
            .compareTo(DateFormat("hh:mm:ss").parse(b.startTime)));
        emit(ScheduleLoaded(newState.scheduleModel, s: newState));
        if (sList.errors.isNotEmpty) {
          emit(ScheduleError(sList.errors[0]));
        }
      } on NetworkError {
        emit(ScheduleError("Failed to fetch data. is your device online?"));
      }
    });

    on<OnDateSelection>((event, emit) {
      //state.selectedDateData =
      ScheduleLoaded newState = state as ScheduleLoaded;
      state.selectedDateData = [];
      state.selctedDate = event.selectedDate;
      for (var e in newState.scheduleModel.data) {
        if (e.convertedDate!.compareTo(event.selectedDate) == 0) {
          state.selectedDateData!.add(e);
        }
      }
      ScheduleLoaded newState2 = state as ScheduleLoaded;
      emit(ScheduleLoaded(newState2.scheduleModel, s: state));
    });

    on<SelectStartTime>((event, emit) {
      state.startTime = event.startTime;
      ScheduleLoaded newState = state as ScheduleLoaded;
      emit(ScheduleLoaded(newState.scheduleModel, s: state));
    });

    on<SelectEndTime>((event, emit) {
      if (state.startTime != null) {
        double val = timeDifference(state.startTime!, event.endTime);
        if (val > 0) {
          Fluttertoast.showToast(msg: "Please Select Valid Time Frame");
        } else {
          state.endTime = event.endTime;
          ScheduleLoaded newState = state as ScheduleLoaded;
          emit(ScheduleLoaded(newState.scheduleModel, s: state));
        }
      } else {
        Fluttertoast.showToast(msg: "Please Select Start Time");
      }
    });

    on<SelectDate>((event, emit) {
      state.date = event.date;
      ScheduleLoaded newState = state as ScheduleLoaded;
      emit(ScheduleLoaded(newState.scheduleModel, s: state));
    });

    on<PopUpEvent>((event, emit) {
      state.up = !state.up;
      ScheduleLoaded newState = state as ScheduleLoaded;
      emit(ScheduleLoaded(newState.scheduleModel, s: state));
    });

    on<SetSchedule>((event, emit) async {
      if (state.nameController!.text == "") {
        Fluttertoast.showToast(msg: "Please enter Name");
      } else if (state.endTime == null) {
        Fluttertoast.showToast(msg: "Please Select End Time");
      } else if (state.date == null) {
        Fluttertoast.showToast(msg: "Please Select date");
      } else {
        Map<String, dynamic> request = {
          "name": state.nameController!.text,
          "startTime":
              "${state.startTime!.hour.toString().padLeft(2, "0")}:${state.startTime!.minute.toString().padLeft(2, "0")}:00",
          "endTime":
              "${state.endTime!.hour.toString().padLeft(2, "0")}:${state.endTime!.minute.toString().padLeft(2, "0")}:00",
          "date": state.getdateString,
          "phoneNumber": "8129959487"
        };
        res.ScheduleResponseModel response =
            await HomepageService().saveSchedule(request);
        if (response.success) {
          Fluttertoast.showToast(msg: response.msg);
          state.up = false;
          ScheduleLoaded newState = state as ScheduleLoaded;
          emit(ScheduleLoaded(newState.scheduleModel, s: state));
          try {
            emit(ScheduleLoading());
            final sList = await HomepageService().fetchScheduleList();
            newState = ScheduleLoaded(sList);
            newState.selectedDateData = [];
            newState.selctedDate = newState.scheduleModel.minDate.convertedDate;
            for (var e in newState.scheduleModel.data) {
              if (e.convertedDate!.compareTo(
                      newState.scheduleModel.minDate.convertedDate) ==
                  0) {
                newState.selectedDateData!.add(e);
              }
            }
            newState.selectedDateData!.sort((a, b) => DateFormat("hh:mm:ss")
                .parse(a.startTime)
                .compareTo(DateFormat("hh:mm:ss").parse(b.startTime)));
            emit(ScheduleLoaded(newState.scheduleModel, s: newState));
            if (sList.errors.isNotEmpty) {
              emit(ScheduleError(sList.errors[0]));
            }
          } on NetworkError {
            emit(ScheduleError("Failed to fetch data. is your device online?"));
          }
        } else {
          state.error = true;
          ScheduleLoaded newState = state as ScheduleLoaded;
          emit(ScheduleLoaded(newState.scheduleModel, s: state));
        }
      }
    });

    on<DismissError>((event, emit) {
      state.error = false;
      ScheduleLoaded newState = state as ScheduleLoaded;
      emit(ScheduleLoaded(newState.scheduleModel, s: state));
    });
  }

  toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  timeDifference(TimeOfDay time1, TimeOfDay time2) {
    double firstTime = toDouble(time1);
    double secondTime = toDouble(time2);
    return firstTime - secondTime;
  }
}
