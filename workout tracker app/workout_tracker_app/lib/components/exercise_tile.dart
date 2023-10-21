import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  final void Function(bool?)? onCheckBoxChanged;

  const ExerciseTile({
    super.key,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isCompleted,
    required this.onCheckBoxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCompleted ? Colors.grey[800] : Colors.grey[500],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        textColor: Colors.white,
        title: Text(exerciseName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            )),
        subtitle: Row(
          children: [
            if (weight.isNotEmpty)
              Chip(
                label: Text(
                  "$weight kg",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            if (reps.isNotEmpty)
              Chip(
                label: Text(
                  "$reps reps",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            if (sets.isNotEmpty)
              Chip(
                label: Text(
                  "$sets sets",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        trailing: Checkbox(
          activeColor: Colors.green,
          value: isCompleted,
          onChanged: onCheckBoxChanged,
        ),
      ),
    );
  }
}
