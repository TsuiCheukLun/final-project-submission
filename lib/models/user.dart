import 'workout.dart';

// The User class is used to represent a user.
class User {
  final String email; // Email of the user
  final String name; // Name of the user
  final int age; // Age of the user
  final int weight; // Weight of the user
  final int height; // Height of the user
  final double bmi; // BMI of the user
  final List<Workout> workouts; // Workouts of the user

  User({
    this.email,
    this.name,
    this.age,
    this.weight,
    this.height,
    this.bmi,
    this.workouts,
  }); // Constructor
}
