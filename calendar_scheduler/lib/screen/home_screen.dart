import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schdule_card.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/provider/schedule_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();
    final selectedDate = provider.selectedDate;
    final schedules = provider.cache[selectedDate] ?? [];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: (selectedDate, focusedDate) =>
                  onDaySelected(selectedDate, focusedDate, context),
            ),
            const SizedBox(height: 8.0),
            TodayBanner(
              selectedDate: selectedDate,
              count: schedules.length,
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final schedule = schedules[index];

                  return Dismissible(
                    key: ObjectKey(schedule.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (DismissDirection direction) {
                      provider.deleteSchedule(id: schedule.id);
                    },
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => ScheduleBottomSheet(
                            selecteDate: selectedDate,
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
                        padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => ScheduleBottomSheet(
              selecteDate: selectedDate,
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
    BuildContext context,
  ) {
    final provider = context.read<ScheduleProvider>();
    provider.changeSelectedDate(
      date: selectedDate,
    );
    provider.getSchedules(date: selectedDate);
  }
}
