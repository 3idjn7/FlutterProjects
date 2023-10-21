import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker_app/components/heat_map.dart';
import 'package:workout_tracker_app/data/workout_data.dart';
import 'package:workout_tracker_app/pages/workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newWorkoutNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("Initializing workout list...");
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[300],
        title: const Text("Create new workout"),
        content: TextField(controller: newWorkoutNameController),
        actions: [
          MaterialButton(onPressed: save, child: const Text("Save")),
          MaterialButton(onPressed: cancel, child: const Text("Cancel")),
        ],
      ),
    );
  }

  void goToWorkoutPage(String workoutName) {
    print("Navigating to workout page for: $workoutName");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkoutPage(workoutName: workoutName)));
  }

  void save() {
    String newWorkoutName = newWorkoutNameController.text;
    print("Adding new workout: $newWorkoutName");
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);
    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newWorkoutNameController.clear();
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

  Container _buildNavigateBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(5.0)),
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.arrow_forward_ios, color: Colors.white),
              Text(' Open',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(String initialName) {
    final controller = TextEditingController(text: initialName);
    showDialog(
      context: context,
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

  Widget _buildHeatMap(WorkoutData value) {
    return MyHeatMap(
        key: ValueKey(value.getWorkoutList().length),
        datasets: value.heatMapDataSet,
        startDateYYYYMMDD: value.getStartDate());
  }

  Widget _buildWorkoutList(WorkoutData value) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: value.getWorkoutList().length,
      itemBuilder: (context, index) {
        var workout = value.getWorkoutList()[index];
        return Dismissible(
          key: ValueKey(workout.name),
          background: _buildNavigateBackground(),
          secondaryBackground: _buildDismissibleBackground(),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              return await _showDeleteDialog(context, workout.name);
            }
            if (direction == DismissDirection.startToEnd) {
              goToWorkoutPage(workout.name);
              return false; // We don't want to actually dismiss the item here.
            }
            return false;
          },
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${workout.name} deleted')));
                value.deleteWorkout(workout.name);
              });
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
            decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(5.0)),
            child: InkWell(
              highlightColor: Colors.black,
              onTap: () => goToWorkoutPage(workout.name),
              onLongPress: () => _showEditDialog(workout.name),
              child: ListTile(
                leading: Image.asset('assets/weightlifting.png', height: 150.0),
                contentPadding: const EdgeInsets.only(
                  left: 18,
                  top: 10,
                  bottom: 10,
                ),
                title: Text(workout.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                    textAlign: TextAlign.left),
                trailing: const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 45.0,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Center(child: Text('Workout Tracker')),
            foregroundColor: Colors.white,
            shadowColor: Colors.black,
            backgroundColor: Colors.grey[800]),
        floatingActionButton: FloatingActionButton(
            onPressed: createNewWorkout,
            backgroundColor: Colors.grey[500],
            child: const Icon(Icons.add)),
        body: ListView(
          children: [_buildHeatMap(value), _buildWorkoutList(value)],
        ),
      ),
    );
  }
}
