abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeBottomNavBarState extends AppStates {}

class AppCreateDatabaseState extends AppStates {}

class AppInsertDatabaseState extends AppStates {}

class AppGetDatabaseState extends AppStates {}

class AppGetDatabaseEmptyState extends AppStates {}

class AppUpdateDatabaseState extends AppStates {}

class AppDeleteDatabaseState extends AppStates {}

class AppChangeSheetState extends AppStates {}

class AppGetDatabaseLoadingState extends AppStates {}

class AppAddEmployeeState extends AppStates {}

class AppEditEmployeeState extends AppStates {
  AppEditEmployeeState(this.data);
  Map data;
}
