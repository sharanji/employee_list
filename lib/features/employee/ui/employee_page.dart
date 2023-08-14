import 'package:employee_list/features/employee/model/employee_model.dart';
import 'package:employee_list/features/employee/ui/add_employe_page.dart';
import 'package:employee_list/shared/cubit.dart';
import 'package:employee_list/shared/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:intl/intl.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({super.key});

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
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
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          appBloc.employeeLists.isEmpty && appBloc.oldemployeeLists.isEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 200,
                    ),
                    Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/empty_list.png'),
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (appBloc.employeeLists.isNotEmpty)
                          Container(
                            color: Color.fromARGB(255, 232, 232, 232),
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            child: const Text(
                              'Current employees',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                          ),
                        for (int i = 0; i < appBloc.employeeLists.length; i++)
                          buildDataList(appBloc.employeeLists[i]),
                        if (appBloc.oldemployeeLists.isNotEmpty)
                          Container(
                            color: Color.fromARGB(255, 232, 232, 232),
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            child: const Text(
                              'Previous employees',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                          ),
                        for (int i = 0;
                            i < appBloc.oldemployeeLists.length;
                            i++)
                          buildDataList(appBloc.oldemployeeLists[i]),
                      ],
                    ),
                  ),
                )
        ],
      ),
      floatingActionButton: InkWell(
        onTap: () {
          appBloc.emit(AppAddEmployeeState());
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildDataList(Employee data) {
    final appBloc = BlocProvider.of<AppCubit>(context);

    return GestureDetector(
      onTap: () {
        appBloc.emit(
          AppEditEmployeeState(
            data.toJson(),
          ),
        );
      },
      child: Dismissible(
        key: Key(data.id.toString()),
        background: Container(
          color: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.centerRight,
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (d) {
          appBloc.deleteData(id: data.id!);
        },
        child: ListBody(
          children: [
            ListTile(
              title: Text(data.name!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.position!),
                  Row(
                    children: [
                      Text(
                        DateFormat("d MMM y", 'en_US').format(
                          DateTime.parse(data.fromDate!),
                        ),
                      ),
                      if (data.toDate!.toString() != 'null')
                        Text(
                          " to ${DateFormat("d MMM y", 'en_US').format(
                            DateTime.parse(data.toDate!),
                          )}",
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
