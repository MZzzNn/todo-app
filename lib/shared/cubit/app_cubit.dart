import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app2/modules/screens/archived_tasks.dart';
import 'package:to_do_app2/modules/screens/done_tasks.dart';
import 'package:to_do_app2/modules/screens/new_tasks.dart';
import 'package:to_do_app2/shared/cubit/app_states.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());
  List<Widget>screens=[NewTasks(),DoneTasks(),ArchivedTasks()];
  List<String>titles=['New Tasks','Done Tasks','Archived Tasks'];
  int currentIndex=0;
  IconData fabIcon=Icons.edit;
  bool isBottomSheetShown=false;
  Database database;
  List<Map>tasks=[];

  //////////////////////////////////////////////////////////////////////////////////////


  static AppCubit getCubit(context)=>BlocProvider.of(context);
  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomIndexState());
  }
  void changeBottomSheetState(bool isShow,IconData iconData){
    isBottomSheetShown=isShow;
    fabIcon=iconData;
    emit(AppChangeBottomSheetState());
  }
  // void openBottomSheet(bool isShow,IconData iconData){
  //   isBottomSheetShown=isShow;
  //   fabIcon=iconData;
  //   emit(AppOpenBottomSheetState());
  // }
  void createDatabase(){
     openDatabase('todo.db',version:1,

         onCreate: (database,version){
           print('database is created');

           database.execute(
               'CREATE TABLE tasks (id INTEGER PRIMARY KEY,time TEXT,title TEXT,date TEXT,status TEXT )'
           ).then((value) {
          print('table created');

        }).catchError((error) {
          print('error when creating table ${error.toString()}');
        });
      },
    onOpen: (database){
      print('database opened');
    }
    ).then((value) {

      database=value;
      getAllDatabase(database);
      emit(AppCreateDatabaseState());
    });

  }
  insertDatabase({@required String time, @required String title,
    @required String date,}) async {
    await database.transaction((txn) {
      txn.rawInsert(
          'INSERT INTO tasks(time,title,date,status) VALUES ("$time","$title","$date","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
        getAllDatabase(database);
      }).catchError((error) {
        print('error when inserting new record ${error.toString()}');
      });
      return null;
    });
  }
  void getAllDatabase(database){
  //  tasks=[];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery(' SELECT * FROM tasks ').then((value) {
       tasks=value;
       print(tasks);
       print('value of tasks is $value');
       emit(AppGetDatabaseState());
     });
  }
}