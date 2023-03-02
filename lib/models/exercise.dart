// This file contains the Exercise model class
class Exercise {
  final String name; // Name of the exercise
  final String description; // Description of the exercise
  final int level; // Level of the exercise
  final String image; // Image of the exercise
  final int weight; // Weight of the exercise
  final int sets; // Sets of the exercise
  final int reps; // Reps of the exercise
  final List<String> steps; // Steps of the exercise
  final String video; // Video of the exercise

  Exercise({
    this.name,
    this.description,
    this.level,
    this.image,
    this.weight,
    this.sets,
    this.reps,
    this.steps,
    this.video,
  }); // Constructor
}
