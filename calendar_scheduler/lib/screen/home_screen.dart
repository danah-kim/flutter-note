import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schdule_card.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/controller/schedule.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleController = Get.put(ScheduleController());

    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              MainCalendar(
                selectedDate: scheduleController.selectedDate.value,
                onDaySelected: (selectedDate, focusedDate) => onDaySelected(
                    selectedDate, focusedDate, scheduleController),
              ),
              const SizedBox(height: 8.0),
              TodayBanner(
                selectedDate: scheduleController.selectedDate.value,
                count: scheduleController.schedules.length,
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ListView.builder(
                  itemCount: scheduleController.schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = scheduleController.schedules[index];

                    return Dismissible(
                      key: ObjectKey(schedule.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (DismissDirection direction) {
                        scheduleController.deleteSchedule(id: schedule.id);
                      },
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => ScheduleBottomSheet(
                              selecteDate:
                                  scheduleController.selectedDate.value,
                              id: schedule.id,
                              startTime: schedule.startTime,
                              endTime: schedule.endTime,
                              content: schedule.content,
                            ),
                            isDismissible: true,
                            isScrollControlled: true,
                          );
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(bottom: 8.0, left: 8.0),
                          child: ScheduleCard(
                            startTime: schedule.startTime,
                            endTime: schedule.endTime,
                            content: schedule.content,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => ScheduleBottomSheet(
              selecteDate: scheduleController.selectedDate.value,
            ),
            isDismissible: true,
            isScrollControlled: true,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void onDaySelected(
    DateTime selectedDate,
    DateTime focusedDate,
    ScheduleController scheduleController,
  ) {
    scheduleController.changeSelectedDate(date: selectedDate);
    scheduleController.getSchedules(date: selectedDate);
  }
}
