import 'exercise.dart';

// The Workout class is used to represent a workout.
class Workout {
  final int id; // ID of the workout
  final String name; // Name of the workout
  final DateTime date; // Date of the workout
  final List<Exercise> exercises; // Exercises of the workout
  final int weight; // Weight of the workout
  final int sets; // Sets of the workout
  final int reps; // Reps of the workout
  final String result; // Plan indicator of the workout
  final String mode_type; // Mode type of the workout

  Workout(
      {this.id,
      this.name,
      this.date,
      this.exercises,
      this.weight,
      this.sets,
      this.reps,
      this.result,
      this.mode_type}); // Constructor
}
