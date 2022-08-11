part of 'schedule_bloc.dart';

class ScheduleState {
  TextEditingController? nameController = TextEditingController();
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  DateTime? date;
  DateTime? selctedDate;
  bool error = false;
  bool up = false;
  List<Data>? selectedDateData = [];


  ScheduleState({this.nameController,this.selectedDateData, this.date,this.endTime,this.error = false,this.startTime});

  ScheduleState.named(ScheduleState? s){
    if(s!=null){
      nameController = s.nameController;
      startTime = s.startTime;
      endTime = s.endTime;
      selctedDate = s.selctedDate;
      date = s.date;
      error = s.error;
      up = s.up;
      selectedDateData = s.selectedDateData;
    }else{
      nameController = TextEditingController();
      error = false;
      up = false;
      selectedDateData = [];
    }
  }

  ScheduleState copywith({TextEditingController? nameCon,TimeOfDay? startT,TimeOfDay? endT,DateTime? dat,bool? err,List<Data>? selectedDateDt}) => ScheduleState(
    nameController: nameCon ??  nameController,
    startTime: startT ?? startTime,
    endTime: endT ?? endTime,
    date: dat ?? date,
    error: err ?? error,
    selectedDateData: selectedDateDt ?? selectedDateData
  );

  get getStartTimeString => startTime == null
      ? ""
      : DateFormat("h:mma").format(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          startTime!.hour,
          startTime!.minute));

  get getEndTimeString => endTime == null
      ? ""
      : DateFormat("h:mma").format(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          endTime!.hour,
          endTime!.minute));

  get getdateString =>
      date == null ? "" : DateFormat('dd/MM/yyyy').format(date!);
}

class ScheduleInitial extends ScheduleState {
  ScheduleInitial() : super(nameController: TextEditingController(),selectedDateData: [],error: false);
}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  late ScheduleModel scheduleModel;

  ScheduleLoaded(this.scheduleModel,{ScheduleState? s}) : super.named(s);
}

class ScheduleError extends ScheduleState {
  final String? message;
  ScheduleError(this.message);
}
