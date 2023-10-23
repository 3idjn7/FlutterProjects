import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker_app/data/workout_data.dart';
import 'package:workout_tracker_app/pages/widgets/create_new_workout_dialog.dart';
import 'package:workout_tracker_app/pages/workout_page.dart';

class WorkoutService {
  final BuildContext _context;
  final TextEditingController newWorkoutNameController;

  WorkoutService(this._context, this.newWorkoutNameController);

  void createNewWorkout() {
    showDialog(
      context: _context,
      builder: (context) => CreateNewWorkoutDialog(
        controller: newWorkoutNameController,
        onSave: save,
        onCancel: cancel,
      ),
    );
  }

  void goToWorkoutPage(String workoutName) {
    print("Navigating to workout page for: $workoutName");
    Navigator.push(
        _context,
        MaterialPageRoute(
            builder: (context) => WorkoutPage(workoutName: workoutName)));
  }

  void save() {
    String newWorkoutName = newWorkoutNameController.text;
    print("Adding new workout: $newWorkoutName");
    Provider.of<WorkoutData>(_context, listen: false).addWorkout(newWorkoutName);
    Navigator.pop(_context);
    clear();
  }

  void cancel() {
    Navigator.pop(_context);
    clear();
  }

  void clear() {
    newWorkoutNameController.clear();
  }

  Future<bool> showDeleteDialog(BuildContext context, String itemName) async {
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

  void showEditDialog(String initialName) {
    final controller = TextEditingController(text: initialName);
    showDialog(
      context: _context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Workout Name'),
        content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Workout Name")),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Provider.of<WorkoutData>(context, listen: false)
                    .updateWorkoutName(initialName, controller.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
        ],
      ),
    );
  }
}
