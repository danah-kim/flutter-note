import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/provider/schedule_provider.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = SchduleDatabase();
  final scheduleProvider = ScheduleProvider(database);

  scheduleProvider.initSchedules();

  runApp(
    ChangeNotifierProvider(
      create: (_) => scheduleProvider,
      child: MaterialApp(
        title: 'Calendar',
        home: HomeScreen(),
      ),
    ),
  );
}
