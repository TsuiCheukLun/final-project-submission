import 'package:flutter/material.dart';

// This class is used to create a list tile that displays the user's training plan.
class TrainingPlanItem extends StatelessWidget {
  final String exerciseName; // The name of the exercise
  final String day; // The day of the week
  final int sets; // The number of sets
  final int reps; // The number of reps

  TrainingPlanItem({
    this.exerciseName,
    this.day,
    this.sets,
    this.reps,
  }); // The constructor

// The build method is used to create the list tile.
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(exerciseName),
      subtitle: Text('$sets sets x $reps reps'),
      trailing: Text(day),
    );
  }
}
