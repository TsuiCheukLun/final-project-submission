import 'package:sqflite/sqflite.dart' as sql;
import 'package:gymapp/models/workout.dart';
import 'package:gymapp/models/bmi.dart';
import 'package:gymapp/utils/converter.dart';

// The TrainingService class is used to manage the database.
class TrainingService {
  static Future<void> setup() async {
    // Open or create the database
    await sql.openDatabase(
      'trainings.db',
      version: 2,
      onCreate: (sql.Database db, int version) async {
        await db.execute(
            'CREATE TABLE trainings (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, weight INTEGER, sets INTEGER, reps INTEGER, date DATETIME, mode_type TEXT, result TEXT)');
        await db.execute(
            'CREATE TABLE bmi (id INTEGER PRIMARY KEY AUTOINCREMENT, bmi REAL, height REAL, weight REAL, date DATETIME)');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion == 1) {
          // update the trainings table to add the field TEXT plan_indicator and TEXT mode_type
          await db.execute('ALTER TABLE trainings ADD COLUMN mode_type TEXT');
          await db.execute('ALTER TABLE trainings ADD COLUMN result TEXT');
        }
      },
    );
  }

// The saveBMI method is used to save the BMI data.
  static Future<void> saveBMI(BMI bmi) async {
    final db = await sql.openDatabase('trainings.db');

    await db.insert(
      'bmi',
      {
        'bmi': bmi.bmi,
        'height': bmi.height,
        'weight': bmi.weight,
        'date': bmi.date.toIso8601String(),
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    await db.close();
  }

// The getLatestBMI method is used to get the latest BMI data.
  static Future<BMI> getLatestBMI() async {
    final db = await sql.openDatabase('trainings.db');

    final latestData = await db.query('bmi', orderBy: 'date DESC', limit: 1);
    await db.close();

    if (latestData.isEmpty) {
      return null;
    }

    return BMI(
      bmi: latestData[0]['bmi'],
      height: latestData[0]['height'],
      weight: latestData[0]['weight'],
      date: DateTime.parse(latestData[0]['date']),
    );
  }

// The getAllBMI method is used to get all the BMI data.
  static Future<List<BMI>> getAllBMI() async {
    final db = await sql.openDatabase('trainings.db');

    final allData = await db.query('bmi', orderBy: 'date ASC');
    await db.close();

    if (allData.isEmpty) {
      return [];
    }

    return allData
        .map((data) => BMI(
              id: data['id'],
              bmi: data['bmi'],
              height: data['height'],
              weight: data['weight'],
              date: DateTime.parse(data['date']),
            ))
        .toList();
  }

  // The deleteBMI method is used to delete the BMI data.
  static Future<void> deleteBMI(int id) async {
    final db = await sql.openDatabase('trainings.db');

    await db.delete('bmi', where: 'id = ?', whereArgs: [id]);
    await db.close();
  }

// The saveWorkout method is used to save the workout data.
  static Future<void> saveWorkout(Workout workout) async {
    final db = await sql.openDatabase('trainings.db');

    await db.insert(
      'trainings',
      WorkoutConverter.toMap(workout),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

// The getAllWorkouts method is used to get all the workout data.
  static Future<List<Workout>> getAllWorkouts() async {
    final db = await sql.openDatabase('trainings.db');
    final List<Map<String, dynamic>> maps = await db.query('trainings');
    return List.generate(maps.length, (i) {
      return WorkoutConverter.fromMap(maps[i]);
    });
  }

// The deleteWorkout method is used to delete the workout data.
  static Future<void> deleteWorkout(int id) async {
    final db = await sql.openDatabase('trainings.db');

    await db.delete('trainings', where: 'id = ?', whereArgs: [id]);
    await db.close();
  }

  // The countWorkouts method is used to count the workout data.
  static Future<int> countWorkouts() async {
    final db = await sql.openDatabase('trainings.db');

    // find the count of the trainings table, where the result is success
    final count = await db
        .rawQuery('SELECT COUNT(*) FROM trainings WHERE result = "success"');
    await db.close();

    return sql.Sqflite.firstIntValue(count);
  }

  // The countDays method is used to count the days.
  static Future<int> countDays() async {
    final db = await sql.openDatabase('trainings.db');

    final count =
        await db.rawQuery('SELECT COUNT(DISTINCT date) FROM trainings');
    await db.close();

    return sql.Sqflite.firstIntValue(count);
  }

  // The reset method is used to reset the database.
  static Future<void> reset() async {
    final db = await sql.openDatabase('trainings.db');

    await db.delete('trainings');
    await db.delete('bmi');
    await db.close();
  }
}
