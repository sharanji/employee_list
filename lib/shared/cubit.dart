import 'package:bloc/bloc.dart';
import 'package:employee_list/features/employee/model/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:employee_list/shared/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  late Database database;
  List<Employee> oldemployeeLists = [];
  List<Employee> employeeLists = [];

  void createDatabase() {
    openDatabase('employee.db', version: 1, onCreate: (database, version) {
      print('db created');
      database
          .execute(
        'CREATE TABLE employee (id INTEGER PRIMARY KEY,name TEXT,position TEXT,from_date TIMESTAMP ,to_date TIMESTAMP ,time_stamp TIMESTAMP ,status TEXT  )',
      )
          .then((value) {
        print('table created');
      }).catchError((error) {
        print('error when creating table ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print('db opened');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future insertToDatabase({
    required String name,
    required String postition,
    required String fromDate,
    required String? toDate,
  }) async {
    String timeStamp = DateTime.now().toString();

    return await database.transaction(
      (txn) => txn
          .rawInsert(
              'INSERT INTO employee(name,position,from_date,to_date,time_stamp,status) VALUES("$name","$postition","$fromDate","$toDate","$timeStamp","1")')
          .then((value) {
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      }),
    );
  }

  void getDataFromDatabase(database) {
    employeeLists = [];
    oldemployeeLists = [];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM employee').then(
      (value) {
        value.forEach((element) {
          if (element['to_date'].toString() == "null") {
            employeeLists.add(Employee.fromJson(element));
          } else {
            DateTime elementToDate = DateTime.parse(element['to_date']);

            if (elementToDate.isAfter(DateTime.now())) {
              employeeLists.add(Employee.fromJson(element));
            } else {
              oldemployeeLists.add(Employee.fromJson(element));
            }
          }
        });
        if (employeeLists.isEmpty && oldemployeeLists.isEmpty) {
          emit(AppGetDatabaseEmptyState());
          return;
        }
        emit(AppGetDatabaseState());
      },
    );
  }

  void updateData({
    required String name,
    required String position,
    required String from_date,
    required String? to_date,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE employee SET name=?,position=?,from_date=?,to_date=?  WHERE id=?',
      [name, position, from_date, to_date, id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) async {
    database.rawDelete(
      'DELETE FROM employee  WHERE id=?',
      [id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }
}
