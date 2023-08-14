import 'package:employee_list/components/custom_appbar.dart';
import 'package:employee_list/components/datepicker.dart';
import 'package:employee_list/components/todatepicker.dart';
import 'package:employee_list/model/position.dart';
import 'package:employee_list/shared/cubit.dart';
import 'package:employee_list/shared/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:employee_list/components/date_enum.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  bool isNodate = true;
  final _formKey = GlobalKey<FormState>();

  String selectedrole = "Select Role";
  bool selectRoleError = false;
  bool nameError = false;
  TextEditingController nameController = TextEditingController();

  bool today = true;
  @override
  Widget build(BuildContext context) {
    final appBloc = BlocProvider.of<AppCubit>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Employee List',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 40,
                width: double.infinity,
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: nameError
                            ? Colors.red
                            : Color.fromARGB(255, 190, 190, 190),
                        width: nameError ? 1 : 0.5,
                      ),
                    ),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_2_outlined),
                    prefixIconColor: Colors.blue,
                    hintText: 'Employee Name',
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter Employee Name";
                    }
                  },
                ),
              ),
              if (nameError)
                ListBody(
                  children: const [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Please select an position',
                      style: TextStyle(fontSize: 13, color: Colors.red),
                    ),
                  ],
                ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  positionSheet(context);
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectRoleError
                          ? Colors.red
                          : Color.fromARGB(255, 190, 190, 190),
                      width: selectRoleError ? 1 : 0.5,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(children: [
                    const Icon(Icons.work_outline, color: Colors.blue),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      selectedrole,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 91, 91, 91),
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down,
                        size: 30, color: Colors.blue),
                  ]),
                ),
              ),
              if (selectRoleError)
                ListBody(
                  children: const [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Please select an position',
                      style: TextStyle(fontSize: 13, color: Colors.red),
                    ),
                  ],
                ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        var result = await datePicker(context, fromDate);
                        if (result == null) return;

                        if (DateFormat("d MMM y", 'en_US')
                                .format(DateTime.now()) ==
                            DateFormat("d MMM y", 'en_US').format(result)) {
                          today = true;
                        } else {
                          today = false;
                        }

                        if (fromDate.isAfter(toDate)) {
                          isNodate = true;
                        }

                        setState(() {
                          fromDate = result;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 2.5,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 190, 190, 190),
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(children: [
                          const Icon(Icons.work_outline, color: Colors.blue),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            today
                                ? "Today"
                                : DateFormat("d MMM y", 'en_US')
                                    .format(fromDate),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 91, 91, 91),
                              fontSize: 16,
                            ),
                          ),
                        ]),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.blue,
                    ),
                    InkWell(
                      onTap: () async {
                        var result =
                            await todatePicker(context, fromDate, toDate);
                        if (result == null) return;

                        if (result[0] == SelectedDate.noDate) {
                          isNodate = true;
                        } else {
                          isNodate = false;
                          toDate = result[1];
                        }
                        setState(() {});
                      },
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 2.5,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 190, 190, 190),
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(children: [
                          const Icon(Icons.work_outline, color: Colors.blue),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            isNodate
                                ? 'No date'
                                : DateFormat("d MMM y", 'en_US').format(toDate),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 91, 91, 91),
                              fontSize: 16,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  appBloc.emit(AppGetDatabaseState());
                },
                child: Container(
                  height: 35,
                  width: 65,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 228, 243, 255),
                    borderRadius: BorderRadius.circular(5),
                    // border: Border.all(color: Colors.blue),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: () {
                  nameError = selectRoleError = false;
                  if (selectedrole == 'Select Role') {
                    setState(() {
                      selectRoleError = true;
                    });
                  }
                  if (nameController.text == '') {
                    setState(() {
                      nameError = true;
                    });
                  }
                  if (!nameError & !selectRoleError) {
                    appBloc.insertToDatabase(
                      name: nameController.text,
                      postition: selectedrole,
                      fromDate: fromDate.toString(),
                      toDate: isNodate ? null : toDate.toString(),
                    );
                  }
                },
                child: Container(
                  height: 35,
                  width: 65,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                    // border: Border.all(color: Colors.blue),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 25),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void positionSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Wrap(
              children: <Widget>[
                for (int i = 0; i < POSITIONS.length; i++)
                  ListBody(
                    children: [
                      ListTile(
                        // leading: const Icon(Icons.music_note),
                        title: Text(POSITIONS[i]),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            selectedrole = POSITIONS[i];
                          });
                        },
                      ),
                      const Divider(),
                    ],
                  ),
              ],
            ),
          );
        });
  }

  dynamic datePicker(context, selectedDate) {
    return showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(15),
            content: DatePicker(selectedDate),
          );
        });
  }

  dynamic todatePicker(context, selectedDate, toDate) {
    return showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(15),
            content: ToDatePicker(
              selectedDate,
              toDate,
              isNodate: isNodate,
            ),
          );
        });
  }
}
