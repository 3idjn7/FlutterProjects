import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker_app/data/workout_data.dart';
import 'package:workout_tracker_app/pages/home_page.dart';

void main() async {
  //initialize hive
  await Hive.initFlutter();

  //open a hive box
  await Hive.openBox("workout_database1");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutData(),
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.grey,
        ),
        home: const HomePage(),
      ),
    );
  }
}
