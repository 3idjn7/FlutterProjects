import 'package:flutter/material.dart';
import 'package:workout_tracker_app/data/hive_database.dart';
import 'package:workout_tracker_app/datetime/date_time.dart';
import 'package:workout_tracker_app/models/exercise.dart';
import 'package:workout_tracker_app/models/workout.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();

  List<Workout> workoutList = [
    // default workout
    Workout(
      name: "Upper Body",
      exercises: [
        Exercise(name: "Bicep Curls", weight: "10", reps: "10", sets: "3"),
      ],
    ),
    Workout(
      name: "Lower Body",
      exercises: [
        Exercise(name: "Squats", weight: "10", reps: "10", sets: "3"),
      ],
    ),
  ];

  // if there are workouts already in database, then get that workout list
  void initializeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    } else {
      // otherwise use default workouts
      db.saveToDatabase(workoutList);
    }
    // load heat map
    loadHeatMap();
  }

  //get the list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  //get length of a given workout
  int numberOfExcercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }

  //add a workout
  void addWorkout(String name) {
    //add a new workout with a blank list of excercises
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();

    //save to database
    db.saveToDatabase(workoutList);
  }

  //add an excercise to a workout
  void addExcercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    //find the relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
      Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets),
    );

    notifyListeners();

    //save to database
    db.saveToDatabase(workoutList);
  }

  void deleteWorkout(String workoutName) {
    // Find the index of the workout to delete.
    int indexToDelete =
        workoutList.indexWhere((workout) => workout.name == workoutName);

    // If the workout is found, remove it from the list.
    if (indexToDelete != -1) {
      workoutList.removeAt(indexToDelete);

      // Notify listeners to rebuild UI and save to database.
      notifyListeners();
      db.saveToDatabase(workoutList);
    }
  }

  void deleteExercise(String workoutName, String exerciseName) {
    // Find the relevant workout.
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    // Find the index of the exercise to delete.
    int indexToDelete = relevantWorkout.exercises
        .indexWhere((exercise) => exercise.name == exerciseName);

    // If the exercise is found, remove it from the list.
    if (indexToDelete != -1) {
      relevantWorkout.exercises.removeAt(indexToDelete);

      // Notify listeners to rebuild UI and save to database.
      notifyListeners();
      db.saveToDatabase(workoutList);
    }
  }

  //check off excercise
  void checkOffExercise(String workoutName, String exerciseName) {
    //find the relevant workout and relevant exercise in that workout
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    //check off boolean to show user compelted the exercise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    DateTime today = DateTime.now();
    String todayString = convertDateTimeToYYYYMMDD(today);

    if (relevantExercise.isCompleted) {
      //If the exercise is completed, increate completionStatus for the day by 1
      db.incrementCompletionStatus(todayString);
    } else {
      db.decrementCompletionStatus(todayString);
    }
    print('tapped');

    notifyListeners();

    //save to database
    db.saveToDatabase(workoutList);

    //load heat map
    loadHeatMap();
  }

  void updateWorkoutName(String oldName, String newName) {
    // Finding the workout with the old name.
    int indexToUpdate =
        workoutList.indexWhere((workout) => workout.name == oldName);

    // If the workout is found, update its name.
    if (indexToUpdate != -1) {
      workoutList[indexToUpdate].name = newName;

      // Notify listeners to rebuild UI and save to database.
      notifyListeners();
      db.saveToDatabase(workoutList);
    }
  }

  //return relevant workout object, given a workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);

    return relevantWorkout;
  }

  //return relevant exercise object, given a workout name + exercise name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    //find relevant workout first
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    //then find the relevant exercise in that workout
    Exercise relevantExercise = relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);
    return relevantExercise;
  }

  //get start date
  String getStartDate() {
    return db.getStartDate();
  }

  Map<DateTime, int> heatMapDataSet = {};

  void loadHeatMap() {
    print("loadHeatMap() called");

    DateTime startDate = createDateTimeObject(getStartDate());
    print("Start date: $startDate");

    //count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    //go from start date to today, and add each completion status to the dataset
    // "COMPLETION_STATUS_yyyymmdd" will be the key in teh database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd =
          convertDateTimeToYYYYMMDD(startDate.add(Duration(days: i)));
      print("Processing date: $yyyymmdd");

      //completion status = 0 or 1
      int completionStatus = db.getCompletionStatus(yyyymmdd);
      print("Completion status for $yyyymmdd: $completionStatus");

      // year
      int year = startDate.add(Duration(days: i)).year;

      // month
      int month = startDate.add(Duration(days: i)).month;

      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): completionStatus
      };

      // add to the heat map dataset
      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
    print("Heatmap dataset now: $heatMapDataSet");
  }
}
