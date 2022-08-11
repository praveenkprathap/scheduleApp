part of 'schedule_bloc.dart';

@immutable
abstract class ScheduleEvent {}

class GetSchedule extends ScheduleEvent {}

class SetSchedule extends ScheduleEvent {
  final BuildContext context;
  SetSchedule({required this.context});
}

class SelectStartTime extends ScheduleEvent {
  final TimeOfDay startTime;
  SelectStartTime({required this.startTime});
}

class SelectEndTime extends ScheduleEvent {
  final TimeOfDay endTime;
  SelectEndTime({required this.endTime});
}

class SelectDate extends ScheduleEvent {
  final DateTime date;
  SelectDate({required this.date});
}

class DismissError extends ScheduleEvent {}

class PopUpEvent extends ScheduleEvent {}

class OnDateSelection extends ScheduleEvent {
  final DateTime selectedDate;
  OnDateSelection({required this.selectedDate});
}
