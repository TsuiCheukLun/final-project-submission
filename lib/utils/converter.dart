import 'package:gymapp/models/exercise.dart';
import 'package:gymapp/models/workout.dart';

// The Converter class is used to convert objects to maps and maps to objects.
class WorkoutConverter {
  // The toMap method is used to convert a Workout object to a map.
  static Map<String, dynamic> toMap(Workout workout) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['name'] = workout.name;
    map['date'] = workout.date.millisecondsSinceEpoch;
    map['weight'] = workout.weight;
    map['sets'] = workout.sets;
    map['reps'] = workout.reps;
    map['result'] = workout.result;
    map['mode_type'] = workout.mode_type;
    return map;
  }

// The fromMap method is used to convert a map to a Workout object.
  static Workout fromMap(Map<String, dynamic> map) {
    return Workout(
        id: map['id'],
        name: map['name'],
        date: DateTime.fromMillisecondsSinceEpoch(map['date']),
        weight: map['weight'],
        sets: map['sets'],
        reps: map['reps'],
        result: map['result'],
        mode_type: map['mode_type']);
  }
}

// The ExerciseConverter class is used to convert objects to maps and maps to objects.
class ExerciseConverter {
  // The toMap method is used to convert an Exercise object to a map.
  static Map<String, dynamic> toMap(Exercise exercise) {
    return {
      'name': exercise.name,
      'description': exercise.description,
      'level': exercise.level,
      'image': exercise.image,
      'weight': exercise.weight,
      'sets': exercise.sets,
      'reps': exercise.reps,
      'steps': exercise.steps,
      'video': exercise.video
    };
  }

// The fromMap method is used to convert a map to an Exercise object.
  static Exercise fromMap(Map<String, dynamic> map) {
    return Exercise(
        name: map['name'],
        description: map['description'],
        level: map['level'],
        image: map['image'],
        weight: map['weight'],
        sets: map['sets'],
        reps: map['reps'],
        steps: map['steps'],
        video: map['video']);
  }
}
