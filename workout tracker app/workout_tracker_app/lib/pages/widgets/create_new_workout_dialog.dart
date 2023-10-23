import 'package:flutter/material.dart';

class CreateNewWorkoutDialog extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  CreateNewWorkoutDialog({
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[300],
      title: const Text("Create new workout"),
      content: TextField(controller: controller),
      actions: [
        MaterialButton(onPressed: onSave, child: const Text("Save")),
        MaterialButton(onPressed: onCancel, child: const Text("Cancel")),
      ],
    );
  }
}
