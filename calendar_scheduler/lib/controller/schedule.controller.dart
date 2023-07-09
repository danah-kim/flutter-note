import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ScheduleController extends GetxController {
  SchduleDatabase? _database;
  Rx<DateTime> selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  ).obs;
  RxList schedules = [].obs;

  @override
  void onInit() {
    super.onInit();
    initSchedules();
  }

  void initSchedules() async {
    _database = SchduleDatabase();
    final res = await _database!.getSchedules(selectedDate.value);

    schedules.value = res;
  }

  void getSchedules({
    required DateTime date,
  }) async {
    final res = await _database!.getSchedules(date);

    schedules.value = res;
  }

  void createSchedule({
    required SchedulesCompanion schedule,
  }) async {
    final tempId = int.parse(DateFormat('HHmmss').format(DateTime.now()));
    final newSchedule = Schedule(
        id: tempId,
        content: schedule.content.value,
        date: schedule.date.value,
        startTime: schedule.startTime.value,
        endTime: schedule.endTime.value);

    schedules.value = [...schedules.value, newSchedule]
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    try {
      final savedSchedule = await _database!.createSchedule(schedule);

      schedules.value = schedules.value
          .map((e) => e.id == tempId
              ? e.copyWith(
                  id: savedSchedule,
                )
              : e)
          .toList();
    } catch (e) {
      schedules.value = schedules.value.where((e) => e.id != tempId).toList();
    }
  }

  void updateSchedule({
    required Schedule schedule,
  }) async {
    final targetDate = schedule.date;
    final targetSchedule = schedules.value.firstWhere(
      (e) => e.id == schedule.id,
    );

    schedules.value = schedules.value
        .map((e) => e.id == schedule.id ? schedule : e)
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    try {
      await _database!.updateSchedule(schedule);
    } catch (e) {
      schedules.value = schedules.value
          .map((e) => e.id == schedule.id ? targetSchedule : e)
          .toList();
    }
  }

  void deleteSchedule({
    required int id,
  }) async {
    final targetSchedule = schedules.value.firstWhere(
      (e) => e.id == id,
    );

    schedules.value = schedules.value.where((e) => e.id != id).toList();

    try {
      await _database?.removeSchedule(id);
    } catch (e) {
      schedules.value = [...schedules.value, targetSchedule]..sort(
          (a, b) => a.startTime.compareTo(
            b.startTime,
          ),
        );
    }
  }

  void changeSelectedDate({
    required DateTime date,
  }) {
    selectedDate.value = date;
  }
}
