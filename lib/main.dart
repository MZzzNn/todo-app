import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app2/layouts/home_layout.dart';
import 'package:to_do_app2/shared/cubit/bloc_obsever.dart';

void main(){
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeLayout(),
    );
  }
}
