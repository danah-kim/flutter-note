import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleProvider extends ChangeNotifier {
  final SchduleDatabase _database;

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  final Map<DateTime, List<Schedule>> cache = {};

  ScheduleProvider(this._database);

  void initSchedules() async {
    final schedules = await _database.getSchedules(selectedDate);

    cache.update(selectedDate, (value) => schedules, ifAbsent: () => schedules);
  }

  void getSchedules({
    required DateTime date,
  }) async {
    final schedules = await _database.getSchedules(date);

    cache.update(date, (value) => schedules, ifAbsent: () => schedules);

    notifyListeners();
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

    cache.update(
      selectedDate,
      (value) => [...value, newSchedule]
        ..sort((a, b) => a.startTime.compareTo(b.startTime)),
      ifAbsent: () => [newSchedule],
    );

    notifyListeners();

    try {
      final savedSchedule = await _database.createSchedule(schedule);

      cache.update(
        selectedDate,
        (value) => value
            .map((e) => e.id == tempId
                ? e.copyWith(
                    id: savedSchedule,
                  )
                : e)
            .toList(),
      );
    } catch (e) {
      cache.update(
        selectedDate,
        (value) => value.where((e) => e.id != tempId).toList(),
      );
    }

    notifyListeners();
  }

  void updateSchedule({
    required Schedule schedule,
  }) async {
    final targetDate = schedule.date;
    final targetSchedule = cache[selectedDate]!.firstWhere(
      (e) => e.id == schedule.id,
    );

    cache.update(
      targetDate,
      (value) => value.map((e) => e.id == schedule.id ? schedule : e).toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime)),
    );

    notifyListeners();

    try {
      await _database.updateSchedule(schedule);
    } catch (e) {
      cache.update(
        targetDate,
        (value) =>
            value.map((e) => e.id == schedule.id ? targetSchedule : e).toList(),
      );

      notifyListeners();
    }
  }

  void deleteSchedule({
    required int id,
  }) async {
    final targetSchedule = cache[selectedDate]!.firstWhere(
      (e) => e.id == id,
    );

    cache.update(
      selectedDate,
      (value) => value.where((e) => e.id != id).toList(),
      ifAbsent: () => [],
    );

    notifyListeners();

    try {
      await _database.removeSchedule(id);
    } catch (e) {
      cache.update(
        selectedDate,
        (value) => [...value, targetSchedule]..sort(
            (a, b) => a.startTime.compareTo(
              b.startTime,
            ),
          ),
      );
    }

    notifyListeners();
  }

  void changeSelectedDate({
    required DateTime date,
  }) {
    selectedDate = date;

    notifyListeners();
  }
}
