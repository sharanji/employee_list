import 'dart:ffi';

import 'package:employee_list/components/datepicker.dart';
import 'package:employee_list/components/quick_select_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';
import './date_enum.dart';

class ToDatePicker extends StatefulWidget {
  ToDatePicker(
    this.selectedDate,
    this.toDate, {
    this.isNodate = false,
    super.key,
  });
  DateTime selectedDate;
  DateTime toDate;
  bool isNodate;
  @override
  State<ToDatePicker> createState() => _ToDatePickerState();
}

class _ToDatePickerState extends State<ToDatePicker> {
  DateTime saticNow = DateTime.now();
  DateTime selectedDate = DateTime.now(); // DateTime.now();
  DateTime toDate = DateTime.now(); // DateTime.now();
  SelectedDate selectedDateEnum = SelectedDate.noDate;
  List<DateTime> selectedDates = [];

  Map weekDays = {
    "Sun": 1,
    "Mon": 2,
    "Tue": 3,
    "Wed": 4,
    "Thu": 5,
    "Fri": 6,
    "Sat": 7,
  };

  late int todayInt;
  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
    toDate = widget.selectedDate;
    todayInt = weekDays[DateFormat.E('en_US').format(saticNow).toString()];
    if (widget.isNodate == false) {
      selectedDates.add(toDate);
      selectedDateEnum = SelectedDate.others;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                selectedDates = [];
                setState(() {
                  selectedDateEnum = SelectedDate.noDate;
                });
              },
              child: QuickSelectButton(
                text: "No Date",
                isSelected: selectedDateEnum == SelectedDate.noDate,
              ),
            ),
            InkWell(
              onTap: () {
                toDate = saticNow;
                selectedDates = [];

                setState(() {
                  selectedDates.add(toDate);
                  selectedDateEnum = SelectedDate.today;
                });
              },
              child: QuickSelectButton(
                text: "Today",
                isSelected: selectedDateEnum == SelectedDate.today,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 280,
          width: 600,
          child: DayPicker.multi(
            selectedDates: selectedDates,
            onChanged: (v) {
              HapticFeedback.selectionClick();
              selectedDates = [];
              toDate = v.last;
              selectedDates.add(toDate);
              selectedDateEnum = SelectedDate.others;
              if (DateFormat("d MMM y", 'en_US').format(DateTime.now()) ==
                  DateFormat("d MMM y", 'en_US').format(toDate)) {
                selectedDateEnum = SelectedDate.today;
              }
              setState(() {});
            },
            firstDate: selectedDate.subtract(Duration(hours: saticNow.hour)),
            lastDate: selectedDate.add(
              const Duration(days: 1000),
            ),
          ),
        ),
        const Divider(),
        Row(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(
              Icons.calendar_today,
              color: Colors.blue,
              size: 20,
            ),
            const SizedBox(width: 5),
            Text(
              selectedDateEnum == SelectedDate.noDate
                  ? "No date "
                  : DateFormat("d MMM y", 'en_US').format(toDate),
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 30,
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 228, 243, 255),
                  borderRadius: BorderRadius.circular(5),
                  // border: Border.all(color: Colors.blue),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            InkWell(
              onTap: () {
                Navigator.of(context).pop([selectedDateEnum, toDate]);
              },
              child: Container(
                height: 30,
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                  // border: Border.all(color: Colors.blue),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
