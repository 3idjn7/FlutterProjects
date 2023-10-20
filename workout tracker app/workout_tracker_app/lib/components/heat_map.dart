import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:workout_tracker_app/datetime/date_time.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDateYYYYMMDD;

  const MyHeatMap({
    super.key,
    required this.datasets,
    required this.startDateYYYYMMDD,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: HeatMap(
        startDate: createDateTimeObject(startDateYYYYMMDD),
        endDate: DateTime.now().add(const Duration(days: 29)),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Colors.grey[200],
        textColor: Colors.black,
        fontSize: 16,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 40,
        colorsets: const {
          1: Color.fromARGB(50, 35, 209, 41),
          2: Color.fromARGB(100, 35, 209, 41),
          3: Color.fromARGB(150, 35, 209, 41),
          4: Color.fromARGB(200, 35, 209, 41),
          5: Color.fromARGB(255, 35, 209, 41),
        },
      ),
    );
  }
}
