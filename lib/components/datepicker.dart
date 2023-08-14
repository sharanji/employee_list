import 'dart:ffi';

import 'package:employee_list/components/quick_select_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';
import './date_enum.dart';

class DatePicker extends StatefulWidget {
  DatePicker(this.selectedDate, {super.key});
  DateTime selectedDate = DateTime.now();
  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime saticNow = DateTime.now();
  DateTime selectedDate = DateTime.now(); // DateTime.now();
  SelectedDate selectedDateEnum = SelectedDate.today;
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
    todayInt = weekDays[DateFormat.E('en_US').format(saticNow).toString()];
    computeDay(selectedDate);
  }

  void computeDay(selectedDate) {
    setState(() {
      selectedDateEnum = SelectedDate.others;

      if (DateFormat("d MMM y", 'en_US').format(selectedDate) ==
          DateFormat("d MMM y", 'en_US').format(saticNow)) {
        selectedDateEnum = SelectedDate.today;
        return;
      }
      int selectedDayInt =
          weekDays[DateFormat("E", 'en_US').format(selectedDate)];
      switch (selectedDayInt) {
        case 2:
          if (selectedDate.day > saticNow.day &&
              selectedDate.day < saticNow.day + 7) {
            selectedDateEnum = SelectedDate.nextMonday;
          }
          break;
        case 3:
          if (selectedDate.day > saticNow.day &&
              selectedDate.day < saticNow.day + 7) {
            selectedDateEnum = SelectedDate.nextTuesday;
          }
          break;
        default:
          if (selectedDate.day > saticNow.day &&
              selectedDate.day == saticNow.day + 7) {
            selectedDateEnum = SelectedDate.after1Week;
            return;
          }
      }
    });
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
                selectedDate = saticNow;

                setState(() {
                  selectedDateEnum = SelectedDate.today;
                });
              },
              child: QuickSelectButton(
                text: "Today",
                isSelected: selectedDateEnum == SelectedDate.today,
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  selectedDateEnum = SelectedDate.nextMonday;
                });
                if (todayInt == 2) {
                  selectedDate = saticNow.add(const Duration(days: 7));
                  return;
                }
                if (todayInt > 2) {
                  selectedDate = saticNow.add(Duration(days: 9 - todayInt));
                  return;
                }
                selectedDate = saticNow.add(Duration(days: 2 - todayInt));
              },
              child: QuickSelectButton(
                text: "Next Monday",
                isSelected: selectedDateEnum == SelectedDate.nextMonday,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  selectedDateEnum = SelectedDate.nextTuesday;
                });
                if (todayInt == 3) {
                  selectedDate = saticNow.add(const Duration(days: 7));
                  return;
                }
                if (todayInt > 3) {
                  selectedDate = saticNow.add(Duration(days: 10 - todayInt));
                  return;
                }
                selectedDate = saticNow.add(Duration(days: 3 - todayInt));
              },
              child: QuickSelectButton(
                text: "Next Teusday",
                isSelected: selectedDateEnum == SelectedDate.nextTuesday,
              ),
            ),
            InkWell(
              onTap: () {
                selectedDate = saticNow.add(const Duration(days: 7));

                setState(() {
                  selectedDateEnum = SelectedDate.after1Week;
                });
              },
              child: QuickSelectButton(
                text: "After 1 week",
                isSelected: selectedDateEnum == SelectedDate.after1Week,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 280,
          width: 600,
          child: DayPicker.single(
            selectedDate: selectedDate,
            onChanged: (v) {
              HapticFeedback.selectionClick();
              selectedDate = v;
              computeDay(v);
            },
            firstDate: saticNow.subtract(const Duration(days: 30)),
            lastDate: saticNow.add(const Duration(days: 30)),
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
              DateFormat("d MMM y", 'en_US').format(selectedDate),
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
                Navigator.of(context).pop(selectedDate);
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
