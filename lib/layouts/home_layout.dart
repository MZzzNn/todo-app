import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app2/shared/cubit/app_states.dart';
import 'package:to_do_app2/shared/cubit/app_cubit.dart';
import 'package:to_do_app2/shared/resuable_components/text_form_field.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({Key key}) : super(key: key);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, states) {
         if(states is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.getCubit(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(title: Text(cubit.titles[cubit.currentIndex])),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                currentIndex: cubit.currentIndex,
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'New'),
                  BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
                  BottomNavigationBarItem(icon: Icon(Icons.archive_sharp), label: 'Archived'),
                ]),
            floatingActionButton: FloatingActionButton(
                child: Icon(cubit.fabIcon),
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                      cubit.insertDatabase(title: 'title', time: 'time', date: 'date');

                  } else {
                    scaffoldKey.currentState.showBottomSheet((context) => Container(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildTextFormField(
                                    textLable: 'Task Title',
                                    suffixIcon: Icons.title),
                                SizedBox(
                                  height: 5,
                                ),
                                buildTextFormField(
                                    suffixIcon: Icons.watch_later_outlined,
                                    textLable: 'Time'),
                                SizedBox(
                                  height: 5,
                                ),
                                buildTextFormField(
                                    suffixIcon: Icons.calendar_today,
                                    textLable: 'Date'),
                              ],
                            ),
                          ),
                        ).closed.then((value) {
                      cubit.changeBottomSheetState(false, Icons.edit);
                    });
                    cubit.changeBottomSheetState(true, Icons.edit);
                  }
                }),
          );
        },
      ),
    );
  }
}
