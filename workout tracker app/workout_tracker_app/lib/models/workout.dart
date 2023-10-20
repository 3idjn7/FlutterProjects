import 'package:workout_tracker_app/models/exercise.dart';

class Workout {
  String name;
  final List<Exercise> exercises;

  Workout({
    required this.name,
    required this.exercises,
  });
}
