import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List toDoList = [];

  final _myBox = Hive.box('mybox');

  // first time ever opening this app
  void createInitialData() {
    toDoList = [
      ["Drink water!!", false],
      ["Exercise!!", false]
    ];
  }

  void loadDatabase() {
    toDoList = _myBox.get("TODOLIST");
  }

  void updateDatabase() {
    _myBox.put("TODOLIST", toDoList);
  }
}
