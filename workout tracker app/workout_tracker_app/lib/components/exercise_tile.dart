import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  void Function(bool?)? onCheckBoxChanged;

  ExerciseTile({
    super.key,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isCompleted,
    required this.onCheckBoxChanged,
<<<<<<< HEAD
  });
=======
    });
>>>>>>> 73ff6ec456ab508a0bf5eef712ac4d68a5f0f717

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: ListTile(
<<<<<<< HEAD
        title: Text(
          exerciseName,
        ),
        subtitle: Row(
          children: [
            Chip(
              label: Text("${weight}kg"),
            ),
            Chip(
              label: Text("$reps reps"),
            ),
            Chip(
              label: Text("$sets sets"),
            ),
          ],
        ),
        trailing: Checkbox(
          value: isCompleted,
          onChanged: (value) => onCheckBoxChanged!(value),
        ),
=======
          title: Text(
            exerciseName,
          ),
          subtitle: Row(
            children: [
            Chip(
              label: Text(
                  "${weight}kg"
                ),
              ),
            Chip(
              label: Text(
                "$reps reps"
              ),
            ),

            Chip(
              label: Text(
                "$sets sets"
              ),
            ),
          ],
        ),trailing: Checkbox(
          value: isCompleted,
          onChanged: (value) => onCheckBoxChanged!(value),
          ),
>>>>>>> 73ff6ec456ab508a0bf5eef712ac4d68a5f0f717
      ),
    );
  }
}
