import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/controller/schedule.controller.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selecteDate;
  final int? id;
  final int? startTime;
  final int? endTime;
  final String? content;

  const ScheduleBottomSheet({
    super.key,
    required this.selecteDate,
    this.id,
    this.startTime,
    this.endTime,
    this.content,
  });

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;

  @override
  Widget build(BuildContext context) {
    final scheduleController = Get.put(ScheduleController());
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isEditMode = widget.id != null;

    return Form(
      key: formKey,
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height / 2 + bottomInset,
          color: Colors.white,
          child: Padding(
            padding:
                EdgeInsets.only(left: 8, right: 8, top: 8, bottom: bottomInset),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: '시작 시간',
                        isTime: true,
                        onSaved: (String? val) {
                          startTime = int.parse(val!);
                        },
                        validator: timeValidator,
                        initialValue: widget.startTime?.toString(),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: CustomTextField(
                        label: '종료 시간',
                        isTime: true,
                        onSaved: (String? val) {
                          endTime = int.parse(val!);
                        },
                        validator: timeValidator,
                        initialValue: widget.endTime?.toString(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: CustomTextField(
                    label: '내용',
                    isTime: false,
                    onSaved: (String? val) {
                      content = val!;
                    },
                    validator: contentValidator,
                    initialValue: widget.content,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => isEditMode
                        ? onEditPressed(scheduleController)
                        : onSavePressed(scheduleController),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                    ),
                    child: Text(isEditMode ? '수정' : '저장'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onEditPressed(ScheduleController scheduleController) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      scheduleController.updateSchedule(
        schedule: Schedule(
            id: widget.id!,
            content: content!,
            date: widget.selecteDate,
            startTime: startTime!,
            endTime: endTime!),
      );

      Navigator.of(context).pop();
    }
  }

  void onSavePressed(ScheduleController scheduleController) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      scheduleController.createSchedule(
        schedule: SchedulesCompanion(
          startTime: Value(startTime!),
          endTime: Value(endTime!),
          content: Value(content!),
          date: Value(widget.selecteDate),
        ),
      );

      if (context.mounted) Navigator.of(context).pop();
    }
  }

  String? timeValidator(String? val) {
    if (val == null) return '값을 입력해주세요';

    int? number;

    try {
      number = int.parse(val);
    } catch (e) {
      return '숫자를 입력해주세요';
    }

    if (number < 0 || number > 24) return '0시부터 24시 사이를 입력해주세요';

    return null;
  }

  String? contentValidator(String? val) {
    if (val == null || val.isEmpty) return '값을 입력해주세요';

    return null;
  }
}
