import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  runApp(
    const GetMaterialApp(
      home: MaterialApp(
        title: 'Calendar',
        home: HomeScreen(),
      ),
    ),
  );
}
