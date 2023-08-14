import 'package:employee_list/features/employee/ui/add_employe_page.dart';
import 'package:employee_list/features/employee/ui/edit_employee_page.dart';
import 'package:employee_list/shared/cubit.dart';
import 'package:employee_list/shared/states.dart';
import 'package:flutter/material.dart';
import 'package:employee_list/features/employee/ui/employee_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'block_observer.dart';

void main() {
  BlocOverrides.runZoned(
    () {
      // Use cubits...
    },
    blocObserver: MyBlocObserver(),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  int closecount = 0;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AppCubit()..createDatabase(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: "Roboto",
        ),
        home: WillPopScope(
          onWillPop: () async {
            closecount++;
            if (closecount > 3) {
              return true;
            } else {
              return false;
            }
          },
          child: BlocBuilder<AppCubit, AppStates>(
            builder: (context, state) {
              switch (state.runtimeType) {
                case AppGetDatabaseState:
                  return const EmployeeList();
                case AppAddEmployeeState:
                  return const AddEmployee();
                case AppEditEmployeeState:
                  state = state as AppEditEmployeeState;
                  return EditEmployee(
                    editData: state.data,
                  );
                case AppGetDatabaseEmptyState:
                  return const EmployeeList();
                default:
                  return Scaffold(
                    body: SafeArea(
                      child: Text(
                        state.runtimeType.toString(),
                      ),
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
