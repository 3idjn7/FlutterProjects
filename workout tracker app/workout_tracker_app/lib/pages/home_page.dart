import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker_app/components/heat_map.dart';
import 'package:workout_tracker_app/data/workout_data.dart';
import 'package:workout_tracker_app/pages/widgets/delete_background.dart';
import 'package:workout_tracker_app/pages/widgets/navigate_background.dart';
import 'package:workout_tracker_app/services/workout_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newWorkoutNameController = TextEditingController();
  late WorkoutService workoutService;

  @override
  void initState() {
    super.initState();
    print("Initializing workout list...");
    workoutService = WorkoutService(context, newWorkoutNameController);
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
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
          background: NavigateBackground(),
          secondaryBackground: DeleteBackground(),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              return await workoutService.showDeleteDialog(
                  context, workout.name);

            }
            if (direction == DismissDirection.startToEnd) {
              workoutService.goToWorkoutPage(workout.name);
              (workout.name);
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
              onTap: () => workoutService.goToWorkoutPage(workout.name),

              onLongPress: () => workoutService.showEditDialog(workout.name),
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
            onPressed: workoutService.createNewWorkout,
            backgroundColor: Colors.grey[500],
            child: const Icon(Icons.add)),
        body: ListView(
          children: [_buildHeatMap(value), _buildWorkoutList(value)],
        ),
      ),
    );
  }
}
