import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final OnDaySelected onDaySelected;

  const MainCalendar({
    super.key,
    required this.selectedDate,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_kr',
      onDaySelected: onDaySelected,
      selectedDayPredicate: (day) =>
          day.year == selectedDate.year &&
          day.month == selectedDate.month &&
          day.day == selectedDate.day,
      focusedDay: DateTime.now(),
      firstDay: DateTime(1800, 1, 1),
      lastDay: DateTime(2030, 3, 14),
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
        ),
      ),
      calendarStyle: CalendarStyle(
          isTodayHighlighted: false,
          defaultDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: LIGHT_GREY_COLOR,
          ),
          weekendDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: LIGHT_GREY_COLOR,
          ),
          selectedDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(color: PRIMARY_COLOR, width: 1.0),
          ),
          defaultTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: DARK_GREY_COLOR,
          ),
          weekendTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: DARK_GREY_COLOR,
          ),
          selectedTextStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            color: PRIMARY_COLOR,
          )),
    );
  }
}
