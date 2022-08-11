import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobsample/helper/constants.dart';
import 'package:jobsample/model/schedule_model.dart';
import 'package:jobsample/scheduleBloc/schedule_bloc.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScheduleBloc _scheduleBloc = ScheduleBloc();

  @override
  void initState() {
    _scheduleBloc.add(GetSchedule());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BlocProvider(
      create: (_) => _scheduleBloc,
      child: Scaffold(
          body: Container(
            margin: const EdgeInsets.all(8.0),
            child: BlocListener<ScheduleBloc, ScheduleState>(
              listener: (context, state) {
                if (state is ScheduleError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message!),
                    ),
                  );
                }
              },
              child: BlocBuilder<ScheduleBloc, ScheduleState>(
                builder: (context, state) {
                  if (state is ScheduleInitial) {
                    return _buildLoading();
                  } else if (state is ScheduleLoading) {
                    return _buildLoading();
                  } else if (state is ScheduleLoaded) {
                    return _buildCard(context, state);
                  } else if (state is ScheduleError) {
                    return Container();
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          floatingActionButton: BlocBuilder<ScheduleBloc, ScheduleState>(
              builder: (context, state) {
            if (!state.up) {
              return FloatingActionButton(
                onPressed: () {
                  context.read<ScheduleBloc>().add(PopUpEvent());
                },
                tooltip: 'Add Schedule',
                child: const Icon(Icons.add),
              );
            } else {
              return const SizedBox();
            }
          })),
    ));
  }

  timePicker(Function(TimeOfDay) onComplete) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        onComplete(value);
      }
    });
  }

  Widget labelButton(String label, String value, Function() onTap) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 15, 12, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: AppColor().primaryGrey, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(
              value == "" ? "Select" : value,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: AppColor().primaryColor, fontWeight: FontWeight.w400),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColor().primaryColor,
              size: 12,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, ScheduleLoaded state) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                state.scheduleModel.minDate.convertedDate
                    .toString()
                    .substring(0, 4),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            CalendarTimeline(
              initialDate: state.selctedDate ??
                  state.scheduleModel.minDate.convertedDate,
              firstDate: state.scheduleModel.minDate.convertedDate,
              lastDate: state.scheduleModel.maxDate.convertedDate,
              onDateSelected: (date) {
                context
                    .read<ScheduleBloc>()
                    .add(OnDateSelection(selectedDate: date));
              },
              leftMargin: 10,
              monthColor: Colors.blueGrey,
              dayNameColor: Colors.black54,
              dayColor: Colors.black,
              activeDayColor: Colors.white,
              activeBackgroundDayColor: AppColor().primaryColor,
              // selectableDayPredicate: (date) => date.day != 23,
              locale: 'en_ISO',
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
                decoration: BoxDecoration(
                    color: AppColor().primaryGrey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15)),
                height: MediaQuery.of(context).size.height * 0.7,
                child: state.selectedDateData == null ||
                        state.selectedDateData!.isEmpty
                    ? const Center(
                        child: Text("No Schedule Available in this date"))
                    : ListView.separated(
                        itemCount: state.selectedDateData == null
                            ? 0
                            : state.selectedDateData!.length,
                        itemBuilder: ((context, index) {
                          return Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColor()
                                        .primaryColor
                                        .withOpacity(0.2)),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 25, 10, 25),
                                child: Icon(
                                  Icons.calendar_month,
                                  size: 20,
                                  color: AppColor().primaryColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      timeDifference(
                                          state.selectedDateData![index]
                                              .startTime,
                                          state.selectedDateData![index]
                                              .endTime),
                                      // "${DateFormat("h:mma").format(DateFormat("hh:mm:ss").parse(state.selectedDateData![index].startTime))} - ${DateFormat("h:mma").format(DateFormat("hh:mm:ss").parse(state.selectedDateData![index].endTime))}",
                                      style: TextStyle(
                                          color: AppColor().primaryGrey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      state.selectedDateData![index].name,
                                      style: TextStyle(
                                          color: AppColor().primaryBlack,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        }),
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                "- - -",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: index == 0
                                        ? AppColor().primaryColor
                                        : AppColor().primaryGrey),
                              ),
                            ),
                          );
                        },
                      ))
          ],
        ),
        if (state.up)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                height: state.error
                    ? MediaQuery.of(context).size.height * 0.3
                    : MediaQuery.of(context).size.height * 0.5,
                child: (state.error)
                    ? Container(
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "This overlaps with\nanother schedule and\ncan’t be saved.",
                              style: TextStyle(
                                  color: AppColor().primaryRed,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Please modify and try again.",
                              style: TextStyle(
                                  color: AppColor().primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: () {
                                //Navigator.pop(context);
                                context.read<ScheduleBloc>().add(PopUpEvent());
                                context
                                    .read<ScheduleBloc>()
                                    .add(DismissError());
                              },
                              child: Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  padding: const EdgeInsets.all(15),
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColor().primaryColor),
                                  child: Text(
                                    "Okey",
                                    style: TextStyle(
                                        color: AppColor().primaryWhite,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Add Schedule",
                                  style: TextStyle(
                                      color: AppColor().primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                    alignment: Alignment.centerRight,
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 0, 8),
                                    onPressed: () {
                                      context
                                          .read<ScheduleBloc>()
                                          .add(PopUpEvent());
                                    },
                                    icon: const Icon(Icons.close))
                              ],
                            ),
                            Text(
                              "Name",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: AppColor().primaryGrey,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 5,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom /
                                        2,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColor()
                                        .primaryColor
                                        .withOpacity(0.2)),
                                child: TextField(
                                  controller: state.nameController,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(left: 10),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      //label: const Text("Name"),
                                      fillColor: AppColor().primaryColor),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                "Date & Time",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: AppColor().primaryGrey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColor()
                                        .primaryColor
                                        .withOpacity(0.2)),
                                child: Column(
                                  children: [
                                    labelButton(
                                        "Start Time", state.getStartTimeString,
                                        () {
                                      FocusScope.of(context).unfocus();
                                      timePicker((value) {
                                        context.read<ScheduleBloc>().add(
                                            SelectStartTime(startTime: value));
                                        //setState(() {});
                                      });
                                    }),
                                    labelButton(
                                        "End Time", state.getEndTimeString, () {
                                      FocusScope.of(context).unfocus();
                                      timePicker((value) {
                                        context
                                            .read<ScheduleBloc>()
                                            .add(SelectEndTime(endTime: value));
                                        //setState(() {});
                                      });
                                    }),
                                    labelButton("Date", state.getdateString,
                                        () {
                                      FocusScope.of(context).unfocus();
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2022, 6, 23),
                                              lastDate: DateTime(2024, 1, 5))
                                          .then((value) {
                                        if (value != null) {
                                          context
                                              .read<ScheduleBloc>()
                                              .add(SelectDate(date: value));
                                          //setState(() {});
                                        }
                                      });
                                    }),
                                  ],
                                )),
                            InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                context
                                    .read<ScheduleBloc>()
                                    .add(SetSchedule(context: context));
                              },
                              child: Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  padding: const EdgeInsets.all(15),
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColor().primaryColor),
                                  child: Text(
                                    "Add Schedule",
                                    style: TextStyle(
                                        color: AppColor().primaryWhite,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ],
                        ),
                      )),
          )
      ],
    );
  }

  String timeDifference(String startTime, String endTime) {
    var difference = DateFormat("hh:mm:ss")
        .parse(endTime)
        .difference(DateFormat("hh:mm:ss").parse(startTime))
        .inHours
        .abs();
    return "${DateFormat("h:mma").format(DateFormat("hh:mm:ss").parse(startTime))} - ${DateFormat("h:mma").format(DateFormat("hh:mm:ss").parse(endTime))} ($difference h)";
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
}
