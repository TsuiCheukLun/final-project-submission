import 'package:sqflite/sqflite.dart' as sql;
import 'package:gymapp/models/workout.dart';
import 'package:gymapp/utils/converter.dart';
import 'package:table_calendar/table_calendar.dart';
import './training.dart';

// The InterService class is used to manage many databases.
class InterService {
  // The getFutureWorkouts method is used to get the future workouts.
  static Future<List<Workout>> getFutureWorkouts() async {
    final db = await sql.openDatabase('planlog.db');
    final date = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day); // today
    final List<Map<String, dynamic>> futureWorkouts = await db.query(
      'trainings',
      where: 'date >= ?',
      whereArgs: [date.millisecondsSinceEpoch],
      orderBy: 'date ASC',
    );
    await db.close();

    final List<Workout> finishedWorkout =
        await TrainingService.getAllWorkouts();

    // return the filtered out futureWorkouts, which removes the finishedWorkout
    return futureWorkouts
        .where((workout) => !finishedWorkout.any((finished) =>
            finished.name == workout['name'] &&
            // Check if is same day
            isSameDay(finished.date,
                DateTime.fromMillisecondsSinceEpoch(workout['date'])) &&
            finished.weight == workout['weight'] &&
            finished.reps == workout['reps'] &&
            finished.sets == workout['sets'] &&
            finished.mode_type == workout['mode_type'] &&
            finished.result == 'success'))
        .map((workout) => WorkoutConverter.fromMap(workout))
        .toList();
  }

  // The countFutureWorkouts method is used to count the future workouts.
  static Future<int> countFutureWorkouts() async {
    final db = await sql.openDatabase('planlog.db');
    final date = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day); // today
    final List<Map<String, dynamic>> futureWorkouts = await db.query(
      'trainings',
      where: 'date >= ?',
      whereArgs: [date.millisecondsSinceEpoch],
      orderBy: 'date ASC',
    );
    await db.close();

    final List<Workout> finishedWorkout =
        await TrainingService.getAllWorkouts();

    // return the filtered out futureWorkouts, which removes the finishedWorkout
    return futureWorkouts
        .where((workout) => !finishedWorkout.any((finished) =>
            finished.name == workout['name'] &&
            // Check if is same day
            isSameDay(finished.date,
                DateTime.fromMillisecondsSinceEpoch(workout['date'])) &&
            finished.weight == workout['weight'] &&
            finished.reps == workout['reps'] &&
            finished.sets == workout['sets'] &&
            finished.mode_type == workout['mode_type'] &&
            finished.result == 'success'))
        .length;
  }

  // The countFutureDays method is used to count the future days.
  static Future<int> countFutureDays() async {
    final db = await sql.openDatabase('planlog.db');
    final date = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day); // today
    final List<Map<String, dynamic>> futureWorkouts = await db.query(
      'trainings',
      where: 'date >= ?',
      whereArgs: [date.millisecondsSinceEpoch],
      orderBy: 'date ASC',
    );
    await db.close();

    final List<Workout> finishedWorkout =
        await TrainingService.getAllWorkouts();

    // return the filtered out futureWorkouts, which removes the finishedWorkout
    return futureWorkouts
        .where((workout) => !finishedWorkout.any((finished) =>
            finished.name == workout['name'] &&
            // Check if is same day
            isSameDay(finished.date,
                DateTime.fromMillisecondsSinceEpoch(workout['date'])) &&
            finished.weight == workout['weight'] &&
            finished.reps == workout['reps'] &&
            finished.sets == workout['sets'] &&
            finished.mode_type == workout['mode_type'] &&
            finished.result == 'success'))
        .map((workout) => DateTime.fromMillisecondsSinceEpoch(workout['date']))
        .toSet()
        .length;
  }

  // The countFinishedDays method is used to count the finished days.
  static Future<int> countFinishedDays() async {
    final db = await sql.openDatabase('planlog.db');
    final date = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day); // today
    final List<Map<String, dynamic>> futureWorkouts = await db.query(
      'trainings',
      where: 'date <= ?',
      whereArgs: [date.millisecondsSinceEpoch],
      orderBy: 'date ASC',
    );
    await db.close();

    final List<Workout> finishedWorkout =
        await TrainingService.getAllWorkouts();

    // return the filtered out futureWorkouts, which removes the finishedWorkout
    final unfinishedWorkouts = futureWorkouts
        .where((workout) => !finishedWorkout.any((finished) =>
            finished.name == workout['name'] &&
            // Check if is same day
            isSameDay(finished.date,
                DateTime.fromMillisecondsSinceEpoch(workout['date'])) &&
            finished.weight == workout['weight'] &&
            finished.reps == workout['reps'] &&
            finished.sets == workout['sets'] &&
            finished.mode_type == workout['mode_type'] &&
            finished.result == 'success'))
        .map((workout) => DateTime.fromMillisecondsSinceEpoch(workout['date']))
        .toSet()
        .length;

    return futureWorkouts
            .map((workout) =>
                DateTime.fromMillisecondsSinceEpoch(workout['date']))
            .toSet()
            .length -
        unfinishedWorkouts;
  }

  // The findNextUntrainedWorkout method is used to find the next untrained workout by the workout name.
  static Future<Workout> findNextUntrainedWorkout(String workoutName) async {
    final db = await sql.openDatabase('planlog.db');
    final date = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day); // today
    final List<Map<String, dynamic>> futureWorkouts = await db.query(
      'trainings',
      where: 'date >= ? AND name = ?',
      whereArgs: [date.millisecondsSinceEpoch, workoutName],
      orderBy: 'date ASC',
    );
    await db.close();

    final List<Workout> finishedWorkout =
        await TrainingService.getAllWorkouts();

    // the filtered out futureWorkouts, which removes the finishedWorkout
    final filteredWorkouts = futureWorkouts
        .where((workout) => !finishedWorkout.any((finished) =>
            finished.name == workout['name'] &&
            // Check if is same day
            isSameDay(finished.date,
                DateTime.fromMillisecondsSinceEpoch(workout['date'])) &&
            finished.weight == workout['weight'] &&
            finished.reps == workout['reps'] &&
            finished.sets == workout['sets'] &&
            finished.mode_type == workout['mode_type'] &&
            finished.result == 'success'))
        .map((workout) => WorkoutConverter.fromMap(workout))
        .toList();
    if (filteredWorkouts.length > 0) return filteredWorkouts.first;
    return null;
  }

  // The getTodayWorkouts method is used to get the today workouts, the ID of workout will be marked as -1 if it is finished.
  static Future<List<Workout>> getTodayWorkouts() async {
    final db = await sql.openDatabase('planlog.db');
    final date = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day); // today
    final List<Map<String, dynamic>> todayWorkouts = await db.query(
      'trainings',
      where: 'date >= ? AND date < ?',
      whereArgs: [
        date.millisecondsSinceEpoch,
        date.add(Duration(days: 1)).millisecondsSinceEpoch
      ],
      orderBy: 'date ASC',
    );
    await db.close();

    final List<Workout> finishedWorkout =
        await TrainingService.getAllWorkouts();

    return todayWorkouts
        .map((workout) {
          if (finishedWorkout.any((finished) =>
              finished.name == workout['name'] &&
              // Check if is same day
              isSameDay(finished.date,
                  DateTime.fromMillisecondsSinceEpoch(workout['date'])) &&
              finished.weight == workout['weight'] &&
              finished.reps == workout['reps'] &&
              finished.sets == workout['sets'] &&
              finished.mode_type == workout['mode_type'] &&
              finished.result == 'success')) {
            // if it is finished, mark the id as -1
            return {...workout, 'id': -1};
          } else {
            // Otherwise, mark the id as 1
            return {...workout, 'id': 1};
          }
        })
        .map((workout) => WorkoutConverter.fromMap(workout))
        .toList();
  }
}
