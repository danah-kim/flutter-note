import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schdule_card.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: onDaySelected,
            ),
            const SizedBox(height: 8.0),
            StreamBuilder(
              stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
              builder: (context, snapshot) {
                return TodayBanner(
                  selectedDate: selectedDate,
                  count: snapshot.data?.length ?? 0,
                );
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: StreamBuilder<List<Schedule>>(
                stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final schedule = snapshot.data![index];

                      return Dismissible(
                        key: ObjectKey(schedule.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (DismissDirection direction) {
                          GetIt.I<LocalDatabase>().removeSchedule(schedule.id);
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

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
