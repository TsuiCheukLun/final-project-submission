import 'package:sqflite/sqflite.dart' as sql;
import 'package:gymapp/models/workout.dart';
import 'package:gymapp/utils/converter.dart';

// The PlanService class is used to manage the database.
class PlanService {
  static Future<void> setup() async {
    // Open or create the database
    await sql.openDatabase('planlog.db', version: 1,
        onCreate: (sql.Database db, int version) async {
      await db.execute(
          'CREATE TABLE trainings (id INTEGER PRIMARY KEY AUTOINCREMENT, mode_type TEXT, result TEXT, name TEXT, weight INTEGER, sets INTEGER, reps INTEGER, date DATETIME)');
    });
  }

// The saveWorkout method is used to save the workout data.
  static Future<void> saveWorkout(Workout workout) async {
    final db = await sql.openDatabase('planlog.db');

    await db.insert(
      'trainings',
      WorkoutConverter.toMap(workout),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

// The getAllWorkouts method is used to get all the workout data.
  static Future<List<Workout>> getAllWorkouts() async {
    final db = await sql.openDatabase('planlog.db');
    final List<Map<String, dynamic>> maps = await db.query('trainings');
    return List.generate(maps.length, (i) {
      return WorkoutConverter.fromMap(maps[i]);
    });
  }

// The getTodayWorkouts method is used to get the workout data of today.
  static Future<List<Workout>> getTodayWorkouts() async {
    final db = await sql.openDatabase('planlog.db');
    final List<Map<String, dynamic>> maps = await db
        .query('trainings', where: 'date >= ? AND date < ?', whereArgs: [
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .millisecondsSinceEpoch,
      DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day + 1)
          .millisecondsSinceEpoch
    ]);
    return List.generate(maps.length, (i) {
      return WorkoutConverter.fromMap(maps[i]);
    });
  }

// The deleteWorkout method is used to delete the workout data.
  static Future<void> deleteWorkout(int id) async {
    final db = await sql.openDatabase('planlog.db');

    await db.delete('trainings', where: 'id = ?', whereArgs: [id]);
    await db.close();
  }

  // The deleteWorkoutOnDate method is used to delete the workout data on a specific date.
  static Future<void> deleteWorkoutOnDate(DateTime date) async {
    final db = await sql.openDatabase('planlog.db');

    await db.delete('trainings', where: 'date >= ? AND date < ?', whereArgs: [
      DateTime(date.year, date.month, date.day).millisecondsSinceEpoch,
      DateTime(date.year, date.month, date.day + 1).millisecondsSinceEpoch
    ]);
    await db.close();
  }

  // The deleteWorkoutOnDateRange method is used to delete the workout data on a specific date range.
  static Future<void> deleteWorkoutOnDateRange(
      DateTime startDate, DateTime endDate) async {
    final db = await sql.openDatabase('planlog.db');

    await db.delete('trainings', where: 'date >= ? AND date < ?', whereArgs: [
      DateTime(startDate.year, startDate.month, startDate.day)
          .millisecondsSinceEpoch,
      DateTime(endDate.year, endDate.month, endDate.day + 1)
          .millisecondsSinceEpoch
    ]);
    await db.close();
  }

  // The findNextWorkout method is used to find the next workout data with provided name
  static Future<Workout> findNextWorkout(String name) async {
    final db = await sql.openDatabase('planlog.db');
    // the date of the next workout should be today or later
    final List<Map<String, dynamic>> maps = await db.query('trainings',
        where: 'name = ? AND date >= ?',
        whereArgs: [
          name,
          DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .millisecondsSinceEpoch
        ],
        orderBy: 'date ASC',
        limit: 1);
    await db.close();

    if (maps.isEmpty) {
      return null;
    }

    return WorkoutConverter.fromMap(maps[0]);
  }

  // The countWorkouts method is used to count the number of workouts
  static Future<int> countWorkouts() async {
    final db = await sql.openDatabase('planlog.db');
    final count = await db.rawQuery('SELECT COUNT(*) FROM trainings');
    await db.close();

    return sql.Sqflite.firstIntValue(count);
  }

  // The countWorkoutsOnDate method is used to count the number of workouts on a specific date
  static Future<int> countWorkoutsOnDate(DateTime date) async {
    final db = await sql.openDatabase('planlog.db');
    final count = await db.rawQuery(
        'SELECT COUNT(*) FROM trainings WHERE date >= ? AND date < ?', [
      DateTime(date.year, date.month, date.day).millisecondsSinceEpoch,
      DateTime(date.year, date.month, date.day + 1).millisecondsSinceEpoch
    ]);
    await db.close();

    return sql.Sqflite.firstIntValue(count);
  }

  // The countWorkoutsOnDateRange method is used to count the number of workouts on a specific date range
  static Future<int> countWorkoutsOnDateRange(
      DateTime startDate, DateTime endDate) async {
    final db = await sql.openDatabase('planlog.db');
    final count = await db.rawQuery(
        'SELECT COUNT(*) FROM trainings WHERE date >= ? AND date < ?', [
      DateTime(startDate.year, startDate.month, startDate.day)
          .millisecondsSinceEpoch,
      DateTime(endDate.year, endDate.month, endDate.day + 1)
          .millisecondsSinceEpoch
    ]);
    await db.close();

    return sql.Sqflite.firstIntValue(count);
  }

  // The reset method is used to reset the database.
  static Future<void> reset() async {
    final db = await sql.openDatabase('planlog.db');
    await db.delete('trainings');
    await db.close();
  }
}
