import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker_app/components/exercise_tile.dart';
import 'package:workout_tracker_app/data/workout_data.dart';
import 'package:workout_tracker_app/pages/home_page.dart';
import 'package:workout_tracker_app/pages/widgets/navigator_slide_transition.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    print("Checking off exercise: $exerciseName for workout: $workoutName");
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add a new exercise'),
        backgroundColor: Colors.grey[300],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: exerciseNameController,
              decoration: const InputDecoration(
                hintText: 'Enter exercise name',
              ),
            ),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(
                hintText: 'Enter weight (e.g. 50)',
              ),
            ),
            TextField(
              controller: repsController,
              decoration: const InputDecoration(
                hintText: 'Enter repetitions (e.g. 10)',
              ),
            ),
            TextField(
              controller: setsController,
              decoration: const InputDecoration(
                hintText: 'Enter sets (e.g. 8)',
              ),
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: const Text("Save"),
          ),
          MaterialButton(
            onPressed: cancel,
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void save() {
    String newExerciseName = exerciseNameController.text;
    print("Adding new exercise: $newExerciseName");
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;

    Provider.of<WorkoutData>(context, listen: false).addExcercise(
      widget.workoutName,
      newExerciseName,
      weight,
      reps,
      sets,
    );

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  Container _buildDismissibleBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(5.0)),
      child: const Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.delete, color: Colors.white),
              Text(' Delete',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteDialog(BuildContext context, String itemName) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete?'),
              content: Text('Do you want to delete $itemName?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // User chose NOT to delete.
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true); // User chose to delete.
                  },
                ),
              ],
            );
          },
        ) ??
        false; // If the user dismisses the dialog by clicking outside, it will return false.
  }

  void _navigateBackWithSlide(BuildContext context) {
    Navigator.of(context).pushReplacement(
        buildSlideTransition(pageBuilder: (context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          _navigateBackWithSlide(context);
        }
      },
      child: Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(
              child: Text(
                widget.workoutName,
                textAlign: TextAlign.center,
              ),
            ),
            foregroundColor: Colors.white,
            backgroundColor: Colors.grey[800],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: createNewExercise,
            backgroundColor: Colors.grey[500],
            child: const Icon(Icons.add),
          ),
          body: ListView.builder(
            itemCount: value.numberOfExcercisesInWorkout(widget.workoutName),
            itemBuilder: (context, index) => Dismissible(
              direction: DismissDirection.endToStart,
              key: ValueKey(value
                  .getRelevantWorkout(widget.workoutName)
                  .exercises[index]
                  .name),
              background: _buildDismissibleBackground(),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  return await _showDeleteDialog(
                      context,
                      value
                          .getRelevantWorkout(widget.workoutName)
                          .exercises[index]
                          .name);
                }
                return false;
              },
              onDismissed: (direction) {
                String exerciseToDelete = value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .name;
                value.deleteExercise(widget.workoutName, exerciseToDelete);
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$exerciseToDelete deleted')));
                });
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                child: ExerciseTile(
                  exerciseName: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .name,
                  weight: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .weight,
                  reps: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .reps,
                  sets: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .sets,
                  isCompleted: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .isCompleted,
                  onCheckBoxChanged: (val) => onCheckBoxChanged(
                    widget.workoutName,
                    value
                        .getRelevantWorkout(widget.workoutName)
                        .exercises[index]
                        .name,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
