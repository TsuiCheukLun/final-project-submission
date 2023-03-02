import 'package:flutter/material.dart';
import 'package:gymapp/models/workout.dart';
import 'package:gymapp/services/plan.dart';
import 'package:gymapp/widgets/collapse_card.dart';

// the floorToMultipleOf5 method is used to round a number to the nearest multiple of 5.
int floorToMultipleOf5(num number) {
  return (number.toDouble() / 5).floor() * 5;
}

// The NLP class is used to perform novice linear progression.
class NLPBase {
  static final List<String> types = []; // The types of exercises.
  static final int defaultSmallestWeightIncrement =
      5; // The default smallest weight increment.
  static final Map<String, List<int>> defaultWorkoutOptions =
      {}; // The default workout options.
  static final List<String> workoutOptionDescriptions = [
    'Test Weight',
    "Reps (<12)",
    'Lb Increase',
    '% to Reset'
  ]; // The workout option descriptions.

  final int smallestWeightIncrement; // The smallest weight increment.
  final Map<String, List<int>> workoutOptions; // The workout options.

  final List<String> workoutPlanOrder = []; // The workout plan order.
  final Map<String, List<String>> workoutPlan = {}; // The workout plan.
  final Map<String, List<String>> workoutPlanDescription =
      {}; // The workout plan description.
  final Map<String, List<String>> workoutPlanSetsReps =
      {}; // The workout plan sets and reps.
  final Map<String, List<int>> workoutPlanRatio = {}; // The workout plan ratio.
  final Map<String, Function> workoutSetsFn = {
    'Squat': (opt, i) =>
        ((NLPBase.get5RM(opt, i) - (NLPBase.get5RM(opt, i) * opt[3] / 100)) / i)
            .roundToDouble() *
        i,
    'Front Squat': (opt, i) =>
        ((NLPBase.get5RM(opt, i) - (NLPBase.get5RM(opt, i) * opt[3] / 100)) / i)
            .roundToDouble() *
        i,
    'Bench Press': (opt, i) =>
        ((NLPBase.get5RM(opt, i) - (NLPBase.get5RM(opt, i) * opt[3] / 100)) / i)
            .roundToDouble() *
        i,
    'Power Clean': (opt, i) =>
        ((NLPBase.get5RM(opt, i) - (NLPBase.get5RM(opt, i) * opt[3] / 100)) / i)
            .roundToDouble() *
        i,
    'Deadlift': (opt, i) =>
        ((NLPBase.get5RM(opt, i) - (NLPBase.get5RM(opt, i) * opt[3] / 100)) / i)
            .roundToDouble() *
        i,
    'Press': (opt, i) =>
        ((NLPBase.get5RM(opt, i) - (NLPBase.get5RM(opt, i) * opt[3] / 100)) / i)
            .roundToDouble() *
        i,
    'Chin-Ups': (opt, i) => 0,
    'Pull-Ups': (opt, i) => 0
  }; // The weight calculation for the workout sets.
  final bool Function(String, int) workoutPrediction =
      (_, __) => true; // The workout prediction to display.

  NLPBase(
      this.smallestWeightIncrement, this.workoutOptions); // The constructor.

// The get1RM method is used to calculate the 1RM.
  static double get1RM(List<int> opt) {
    return opt[0] / (1.0278 - (0.0278 * opt[1]));
  }

// The get5RM method is used to calculate the 5RM.
  static double get5RM(List<int> opt, int smallestWeightIncrement) {
    return (get1RM(opt) * (1.0278 - (0.0278 * 5)) / smallestWeightIncrement)
            .roundToDouble() *
        smallestWeightIncrement;
  }

// The calculateNthAppear method is used to calculate the nth appearance of a workout.
  int calculateNthAppear(String workoutName, String planName, int n, int m) {
    int count = -1;
    for (int j = 0; j < 12; j++) {
      // 12 weeks
      for (String workout in workoutPlanOrder) {
        // for each workout
        for (int i = 0; i < workoutPlan[workout].length; i++) {
          // for each workout exercise
          if (workoutPlan[workout][i] == workoutName &&
              workoutPrediction(
                  workoutName,
                  workoutPlanOrder.indexOf(workout) +
                      j * workoutPlanOrder.length +
                      1)) {
            // if the workout is the workoutName and the workout is predicted to be displayed
            count++;
          }
          if (workout == planName && i == n && j == m) {
            // if the workout is the planName and the workout is the nth workout and the workout is the mth week
            return count;
          }
        }
      }
    }
    return count; // if the workout is not found
  }

// The getWorkoutPlanWidget method is used to get the workout plan widget.
  Widget getWorkoutPlanWidget() {
    return Column(
      // the column
      children: [
        for (String workoutName in workoutPlanOrder) // for each workout
          Column(
            children: [
              for (int i = 0;
                  i < workoutPlan[workoutName].length;
                  i++) // for each workout exercise
                ExpandableCard(
                  workoutName, // the workout name
                  workoutPlan[workoutName][i], // the workout exercise
                  Row(
                    children: [
                      Column(children: [
                        Text(''),
                        Text(''),
                        for (int j = 0; j < 12; j++)
                          Text('Session #' +
                              (workoutPlanOrder.indexOf(workoutName) +
                                      j * workoutPlanOrder.length +
                                      1)
                                  .toString()), // the session number
                      ]),
                      for (int j = 0;
                          j <
                              workoutPlanDescription[workoutPlan[workoutName]
                                      [i]]
                                  .length;
                          j++) // for each workout exercise description
                        Column(
                          children: [
                            Text(workoutPlanDescription[workoutPlan[workoutName]
                                    [i]][j] +
                                ' '), // add a space to the end of the description
                            Text(workoutPlanSetsReps[workoutPlan[workoutName]
                                    [i]][j] +
                                ' '), // add a space to the end of the sets and reps
                            for (int k = 0; k < 12; k++) // for each week
                              !workoutPrediction(
                                      workoutPlan[workoutName][i],
                                      workoutPlanOrder.indexOf(workoutName) +
                                          k * workoutPlanOrder.length +
                                          1) // if the workout is not predicted to be displayed
                                  ? Text('')
                                  : workoutPlanRatio[workoutPlan[workoutName][i]]
                                              [j] <
                                          0 // if the workout ratio is negative
                                      ? Text(floorToMultipleOf5(-workoutPlanRatio[workoutPlan[workoutName][i]][j])
                                          .toStringAsFixed(
                                              0)) // display the ratio as absolute value
                                      : Text(workoutSetsFn[workoutPlan[workoutName][i]](workoutOptions[workoutPlan[workoutName][i]], smallestWeightIncrement) >
                                              0 // if the workout sets is greater than 0
                                          ? floorToMultipleOf5((workoutSetsFn[workoutPlan[workoutName][i]](
                                                          workoutOptions[workoutPlan[workoutName][i]],
                                                          smallestWeightIncrement) +
                                                      workoutOptions[workoutPlan[workoutName][i]][2] * calculateNthAppear(workoutPlan[workoutName][i], workoutName, i, k)) *
                                                  workoutPlanRatio[workoutPlan[workoutName][i]][j] /
                                                  100)
                                              .toStringAsFixed(0) // calculate and display the workout sets
                                          : ''),
                          ],
                        )
                    ],
                  ),
                ),
            ],
          ),
      ],
    );
  }

// The checkConflict method is used to check if there exists plan in the target date
  Future<bool> checkConflict(
      Map<String, bool> daysOfWeek, DateTime startDate) async {
    // // get the workout count to init the counter
    // int workoutCount = 0;
    // int workoutMax = workoutPlanOrder.length * 12;

    // // the map that map 0-6 to Monday to Sunday
    // Map<int, String> daysOfWeekMap = {
    //   0: 'Monday',
    //   1: 'Tuesday',
    //   2: 'Wednesday',
    //   3: 'Thursday',
    //   4: 'Friday',
    //   5: 'Saturday',
    //   6: 'Sunday'
    // };

    // // init the map of exercise name to 0
    // Map<String, int> exerciseNameToCount = {
    //   for (String exerciseName in workoutPlanRatio.keys) exerciseName: 0
    // };

    // DateTime currentDate = startDate;
    // int baseDay = startDate.weekday - 1;
    // // generate 12 weeks of workouts
    // for (int i = 0; i < 12; i++) {
    //   // find the day that is true in the week
    //   for (int j = 0; j < 7; j++) {
    //     int day = (baseDay + j) % 7;
    //     if (daysOfWeek[daysOfWeekMap[day]] && workoutCount < workoutMax) {
    //       // if the day is true
    //       // add the workout to the database
    //       var currentWorkout =
    //           workoutPlanOrder[workoutCount % workoutPlanOrder.length];
    //       // generate the workouts for the day
    //       for (int k = 0; k < workoutPlan[currentWorkout].length; k++) {
    //         var workoutName = workoutPlan[currentWorkout][k];
    //         exerciseNameToCount[workoutName] += 1;
    //         for (int j = 0;
    //             j < workoutPlanDescription[workoutName].length;
    //             j++) {
    //           // for each workout exercise description
    //           if (!workoutPrediction(workoutName, workoutCount + 1)) {
    //             // if the workout is not predicted to be displayed
    //             continue;
    //           }
    //           if (workoutPlanRatio[workoutName][j] != 0) {
    //             // if the workout ratio is not 0
    //             // check the database
    //             if(await PlanService.countWorkoutsOnDate(currentDate) > 0){
    //               return true;
    //             }
    //           }
    //         }
    //       }
    //       // update the counter
    //       workoutCount++;
    //     }
    //     currentDate = currentDate.add(Duration(days: 1));
    //   }
    // }
    if (await PlanService.countWorkoutsOnDateRange(
            startDate, startDate.add(Duration(days: 7 * 12))) >
        0) {
      return true;
    }
    return false;
  }

  // The cleanConflict method is used to check if there exists plan in the target date
  Future<void> cleanConflict(
      Map<String, bool> daysOfWeek, DateTime startDate) async {
    // // get the workout count to init the counter
    // int workoutCount = 0;
    // int workoutMax = workoutPlanOrder.length * 12;

    // // the map that map 0-6 to Monday to Sunday
    // Map<int, String> daysOfWeekMap = {
    //   0: 'Monday',
    //   1: 'Tuesday',
    //   2: 'Wednesday',
    //   3: 'Thursday',
    //   4: 'Friday',
    //   5: 'Saturday',
    //   6: 'Sunday'
    // };

    // // init the map of exercise name to 0
    // Map<String, int> exerciseNameToCount = {
    //   for (String exerciseName in workoutPlanRatio.keys) exerciseName: 0
    // };

    // DateTime currentDate = startDate;
    // int baseDay = startDate.weekday - 1;
    // // generate 12 weeks of workouts
    // for (int i = 0; i < 12; i++) {
    //   // find the day that is true in the week
    //   for (int j = 0; j < 7; j++) {
    //     int day = (baseDay + j) % 7;
    //     if (daysOfWeek[daysOfWeekMap[day]] && workoutCount < workoutMax) {
    //       // if the day is true
    //       // add the workout to the database
    //       var currentWorkout =
    //           workoutPlanOrder[workoutCount % workoutPlanOrder.length];
    //       // generate the workouts for the day
    //       for (int k = 0; k < workoutPlan[currentWorkout].length; k++) {
    //         var workoutName = workoutPlan[currentWorkout][k];
    //         exerciseNameToCount[workoutName] += 1;
    //         for (int j = 0;
    //             j < workoutPlanDescription[workoutName].length;
    //             j++) {
    //           // for each workout exercise description
    //           if (!workoutPrediction(workoutName, workoutCount + 1)) {
    //             // if the workout is not predicted to be displayed
    //             continue;
    //           }
    //           if (workoutPlanRatio[workoutName][j] != 0) {
    //             // if the workout ratio is not 0
    //             // check the database
    //             await PlanService.deleteWorkoutOnDate(currentDate);
    //           }
    //         }
    //       }
    //       // update the counter
    //       workoutCount++;
    //     }
    //     currentDate = currentDate.add(Duration(days: 1));
    //   }
    // }
    await PlanService.deleteWorkoutOnDateRange(
        startDate, startDate.add(Duration(days: 7 * 12)));
  }

// The saveToDatabase method is used to save the program to the database.
  Future<void> saveToDatabase(
      Map<String, bool> daysOfWeek, DateTime startDate) async {
    // get the workout count to init the counter
    int workoutCount = 0;
    int workoutMax = workoutPlanOrder.length * 12;

    // the map that map 0-6 to Monday to Sunday
    Map<int, String> daysOfWeekMap = {
      0: 'Monday',
      1: 'Tuesday',
      2: 'Wednesday',
      3: 'Thursday',
      4: 'Friday',
      5: 'Saturday',
      6: 'Sunday'
    };

    // init the map of exercise name to 0
    Map<String, int> exerciseNameToCount = {
      for (String exerciseName in workoutPlanRatio.keys) exerciseName: 0
    };

    DateTime currentDate = startDate;
    int baseDay = startDate.weekday - 1;
    // generate 12 weeks of workouts
    for (int i = 0; i < 12; i++) {
      // find the day that is true in the week
      for (int j = 0; j < 7; j++) {
        int day = (baseDay + j) % 7;
        if (daysOfWeek[daysOfWeekMap[day]] && workoutCount < workoutMax) {
          // if the day is true
          // add the workout to the database
          var currentWorkout =
              workoutPlanOrder[workoutCount % workoutPlanOrder.length];
          // generate the workouts for the day
          for (int k = 0; k < workoutPlan[currentWorkout].length; k++) {
            var workoutName = workoutPlan[currentWorkout][k];
            exerciseNameToCount[workoutName] += 1;
            for (int j = 0;
                j < workoutPlanDescription[workoutName].length;
                j++) {
              // for each workout exercise description
              if (!workoutPrediction(workoutName, workoutCount + 1)) {
                // if the workout is not predicted to be displayed
                continue;
              }
              int sets = 0;
              int reps = 0;
              List<String> desc =
                  workoutPlanSetsReps[workoutName][j].split('x');
              if (desc.length == 2) {
                sets = int.parse(desc[0]);
                reps = int.parse(desc[1]);
              }
              if (desc.length == 1 && desc[0].length > 0) {
                reps = int.parse(desc[0]);
              }
              if (workoutPlanRatio[workoutName][j] < 0) {
                // if the workout ratio is negative
                // add the workout to the database
                await PlanService.saveWorkout(Workout(
                  name: workoutName,
                  date: currentDate,
                  sets: sets,
                  reps: reps,
                  weight: floorToMultipleOf5(-workoutPlanRatio[workoutName][j]),
                  mode_type: workoutPlanDescription[workoutName][j],
                ));
              }
              if (workoutPlanRatio[workoutName][j] > 0) {
                // if the workout ratio is positive
                // add the workout to the database
                await PlanService.saveWorkout(Workout(
                  name: workoutName,
                  date: currentDate,
                  sets: sets,
                  reps: reps,
                  weight: floorToMultipleOf5((workoutSetsFn[workoutName](
                              workoutOptions[workoutName],
                              smallestWeightIncrement) +
                          workoutOptions[workoutName][2] *
                              exerciseNameToCount[workoutName]) *
                      workoutPlanRatio[workoutName][j] /
                      100),
                  mode_type: workoutPlanDescription[workoutName][j],
                ));
              }
            }
          }
          // update the counter
          workoutCount++;
        }
        currentDate = currentDate.add(Duration(days: 1));
      }
    }
  }
}

// The Original Novice Program is a 2 day a week program
class OriginalNoviceProgram extends NLPBase {
  static final types = [
    'Squat',
    'Bench Press',
    'Deadlift',
    'Press',
    'Power Clean'
  ];
  static final defaultSmallestWeightIncrement = 5;
  static final defaultWorkoutOptions = {
    'Squat': [100, 5, 5, 0],
    'Bench Press': [45, 5, 5, 0],
    'Deadlift': [80, 5, 10, 0],
    'Press': [35, 5, 5, 0],
    'Power Clean': [50, 5, 5, 0],
  };

  final workoutPlanOrder = ['Workout A', 'Workout B'];
  final workoutPlan = {
    'Workout A': ['Squat', 'Bench Press', 'Deadlift'],
    'Workout B': ['Squat', 'Press', 'Power Clean']
  };
  final workoutPlanDescription = {
    'Squat': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets'],
    'Bench Press': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets'],
    'Deadlift': ['warmup', 'warmup', 'warmup', 'working sets'],
    'Press': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets'],
    'Power Clean': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets']
  };
  final workoutPlanSetsReps = {
    'Squat': ['2x5', '1x5', '1x3', '1x2', '3x5'],
    'Bench Press': ['2x5', '1x5', '1x3', '1x2', '3x5'],
    'Deadlift': ['2x5', '1x3', '1x2', '1x5'],
    'Press': ['2x5', '1x5', '1x3', '1x2', '3x5'],
    'Power Clean': ['2x5', '1x5', '1x3', '1x2', '5x3']
  };
  final workoutPlanRatio = {
    'Squat': [-45, 40, 60, 80, 100],
    'Bench Press': [-45, 50, 70, 90, 100],
    'Deadlift': [40, 60, 85, 100],
    'Press': [-45, 55, 70, 85, 100],
    'Power Clean': [-45, 55, 70, 85, 100]
  };

  OriginalNoviceProgram(a, b) : super(a, b);
}

// The Practical Programming Novice Program is a 3 day a week program
class PracticalProgrammingNoviceProgram extends NLPBase {
  static final types = [
    'Squat',
    'Bench Press',
    'Deadlift',
    'Press',
  ];
  static final defaultSmallestWeightIncrement = 5;
  static final defaultWorkoutOptions = {
    'Squat': [45, 5, 5, 0],
    'Bench Press': [125, 5, 5, 0],
    'Deadlift': [220, 5, 15, 0],
    'Press': [65, 5, 5, 0],
  };

  final workoutPlanOrder = ['Monday', 'Wednesday', 'Friday'];
  final workoutPlan = {
    'Monday': ['Squat', 'Bench Press', 'Press', 'Chin-Ups'],
    'Wednesday': ['Squat', 'Bench Press', 'Press', 'Deadlift'],
    'Friday': ['Squat', 'Bench Press', 'Press', 'Pull-Ups']
  };
  final workoutPlanDescription = {
    'Squat': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets'],
    'Bench Press': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets'],
    'Deadlift': ['warmup', 'warmup', 'warmup', 'working sets'],
    'Press': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets'],
    'Chin-Ups': ['working sets', '', '', ''],
    'Pull-Ups': ['working sets', '', '', '']
  };
  final workoutPlanSetsReps = {
    'Squat': ['2x5', '1x5', '1x3', '1x2', '3x5'],
    'Bench Press': ['2x5', '1x5', '1x3', '1x2', '3x5'],
    'Deadlift': ['2x5', '1x3', '1x2', '1x5'],
    'Press': ['2x5', '1x5', '1x3', '1x2', '5x3'],
    'Chin-Ups': ['3 sets to failure', '1st Set', '2nd Set', '3rd Set'],
    'Pull-Ups': ['3 sets to failure', '1st Set', '2nd Set', '3rd Set']
  };
  final workoutPlanRatio = {
    'Squat': [-45, 40, 60, 80, 100],
    'Bench Press': [-45, 50, 70, 90, 100],
    'Deadlift': [40, 60, 85, 100],
    'Press': [-45, 55, 70, 85, 100],
    'Chin-Ups': [0, 0, 0, 0],
    'Pull-Ups': [0, 0, 0, 0]
  };
  final workoutPrediction = (name, i) {
    if (name == 'Bench Press') return i % 2 == 0 ? false : true;
    if (name == 'Press') return i % 2 == 1 ? false : true;
    if (name == 'Chin-Ups') return false;
    if (name == 'Pull-Ups') return false;
    return true;
  };

  PracticalProgrammingNoviceProgram(a, b) : super(a, b);
}

// The Wichita Falls Novice Program is a 3 day a week program
class WichitaFallsNoviceProgram extends NLPBase {
  static final types = [
    'Squat',
    'Bench Press',
    'Power Clean',
    'Deadlift',
    'Press',
  ];
  static final defaultSmallestWeightIncrement = 5;
  static final defaultWorkoutOptions = {
    'Squat': [215, 5, 5, 0],
    'Bench Press': [125, 5, 5, 0],
    'Power Clean': [45, 5, 5, 0],
    'Deadlift': [185, 5, 15, 0],
    'Press': [65, 5, 5, 0],
  };

  final workoutPlanOrder = ['Monday', 'Wednesday', 'Friday'];
  final workoutPlan = {
    'Monday': ['Squat', 'Bench Press', 'Press', 'Chin-Ups'],
    'Wednesday': ['Squat', 'Bench Press', 'Press', 'Deadlift', 'Power Clean'],
    'Friday': ['Squat', 'Bench Press', 'Press', 'Pull-Ups']
  };
  final workoutPlanDescription = {
    'Squat': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets'],
    'Bench Press': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets'],
    'Power Clean': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets'],
    'Deadlift': ['warmup', 'warmup', 'warmup', 'working sets'],
    'Press': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets'],
    'Chin-Ups': ['working sets', '', '', ''],
    'Pull-Ups': ['working sets', '', '', '']
  };
  final workoutPlanSetsReps = {
    'Squat': ['2x5', '1x5', '1x3', '1x2', '3x5'],
    'Bench Press': ['2x5', '1x5', '1x3', '1x2', '3x5'],
    'Power Clean': ['2x5', '1x5', '1x3', '1x2', '5x3'],
    'Deadlift': ['2x5', '1x3', '1x2', '1x5'],
    'Press': ['2x5', '1x5', '1x3', '1x2', '5x3'],
    'Chin-Ups': ['3 sets to failure', '1st Set', '2nd Set', '3rd Set'],
    'Pull-Ups': ['3 sets to failure', '1st Set', '2nd Set', '3rd Set']
  };
  final workoutPlanRatio = {
    'Squat': [-45, 40, 60, 80, 100],
    'Bench Press': [-45, 50, 70, 90, 100],
    'Power Clean': [-45, 55, 70, 85, 100],
    'Deadlift': [40, 60, 85, 100],
    'Press': [-45, 55, 70, 85, 100],
    'Chin-Ups': [0, 0, 0, 0],
    'Pull-Ups': [0, 0, 0, 0]
  };
  final workoutPrediction = (name, i) {
    if (name == 'Bench Press') return i % 2 == 0 ? false : true;
    if (name == 'Press') return i % 2 == 1 ? false : true;
    if (name == 'Deadlift') return i % 2 == 1 ? false : true;
    if (name == 'Chin-Ups') return false;
    if (name == 'Pull-Ups') return false;
    return true;
  };

  WichitaFallsNoviceProgram(a, b) : super(a, b);
}

// The Onus Wunsler Program is a 2 day a week program
class OnusWunslerProgram extends NLPBase {
  static final types = [
    'Squat',
    'Bench Press',
    'Press',
    'Deadlift',
    'Power Clean',
  ];
  static final defaultSmallestWeightIncrement = 5;
  static final defaultWorkoutOptions = {
    'Squat': [100, 5, 5, 0],
    'Bench Press': [100, 5, 5, 0],
    'Power Clean': [100, 5, 5, 0],
    'Deadlift': [100, 5, 15, 0],
    'Press': [100, 5, 5, 0],
  };

  final workoutPlanOrder = ['Workout A', 'Workout B'];
  final workoutPlan = {
    'Workout A': ['Squat', 'Press', 'Deadlift', 'Power Clean'],
    'Workout B': [
      'Squat',
      'Bench Press',
      'Back Extensions(or Glute Ham Raises)',
      'Chin-Ups'
    ]
  };
  final workoutPlanDescription = {
    'Squat': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets'],
    'Bench Press': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets'],
    'Power Clean': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets'],
    'Deadlift': ['warmup', 'warmup', 'warmup', 'working sets'],
    'Press': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets'],
    'Chin-Ups': ['working sets', '', '', ''],
    'Back Extensions(or Glute Ham Raises)': ['working sets']
  };
  final workoutPlanSetsReps = {
    'Squat': ['2x5', '1x5', '1x3', '1x2', '3x5'],
    'Bench Press': ['5', '5', '5', '', '5'],
    'Power Clean': ['2x5', '1x5', '1x3', '1x2', '5x3'],
    'Deadlift': ['2x5', '1x3', '1x2', '1x5'],
    'Press': ['2x5', '1x5', '1x3', '1x2', '5x3'],
    'Chin-Ups': ['3 sets to failure', '1st Set', '2nd Set', '3rd Set'],
    'Back Extensions(or Glute Ham Raises)': ['3-5x10']
  };
  final workoutPlanRatio = {
    'Squat': [-45, 40, 60, 80, 100],
    'Bench Press': [-45, 50, 70, 90, 100],
    'Power Clean': [-45, 55, 70, 85, 100],
    'Deadlift': [40, 60, 85, 100],
    'Press': [-45, 55, 70, 85, 100],
    'Chin-Ups': [0, 0, 0, 0],
    'Back Extensions(or Glute Ham Raises)': [0]
  };
  final workoutPrediction = (name, i) {
    if (name == 'Deadlift') return i % 4 == 1 ? true : false;
    if (name == 'Power Clean') return i % 4 == 3 ? true : false;
    if (name == 'Chin-Ups') return false;
    if (name == 'Back Extensions(or Glute Ham Raises)') return false;
    return true;
  };

  OnusWunslerProgram(a, b) : super(a, b);
}

// The Advanced Novice Program is a 3 day a week program
class AdvancedNoviceProgram extends NLPBase {
  static final workoutOptionDescriptions = [
    'Current Max',
    "Reps (<12)",
    'Lb Increase',
    '% to Reset'
  ];

  static final types = [
    'Squat',
    'Front Squat',
    'Bench Press',
    'Power Clean',
    'Deadlift',
    'Press',
  ];
  static final defaultSmallestWeightIncrement = 5;
  static final defaultWorkoutOptions = {
    'Squat': [100, 5, 5, 0],
    'Front Squat': [100, 5, 5, 0],
    'Bench Press': [100, 5, 5, 0],
    'Power Clean': [100, 5, 5, 0],
    'Deadlift': [100, 5, 15, 0],
    'Press': [100, 5, 5, 0],
  };

  final workoutPlanOrder = ['Monday', 'Wednesday', 'Friday'];
  final workoutPlan = {
    'Monday': ['Squat', 'Bench Press', 'Press', 'Chin-Ups'],
    'Wednesday': [
      'Front Squat',
      'Bench Press',
      'Press',
      'Deadlift',
      'Power Clean'
    ],
    'Friday': ['Squat', 'Bench Press', 'Press', 'Pull-Ups']
  };
  final workoutPlanDescription = {
    'Squat': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets'],
    'Front Squat': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets'],
    'Bench Press': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets'],
    'Power Clean': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets'],
    'Deadlift': ['warmup', 'warmup', 'warmup', 'working sets'],
    'Press': ['warmup', 'warmup', 'warmup', 'warmup', 'working sets'],
    'Chin-Ups': ['working sets', '', '', ''],
    'Pull-Ups': ['working sets', '', '', '']
  };
  final workoutPlanSetsReps = {
    'Squat': ['2x5', '1x5', '1x3', '1x2', '3x5'],
    'Front Squat': ['2x5', '1x5', '1x3', '1x2', '3x5'],
    'Bench Press': ['2x5', '1x5', '1x3', '1x2', '3x5'],
    'Power Clean': ['2x5', '1x5', '1x3', '1x2', '5x3'],
    'Deadlift': ['2x5', '1x3', '1x2', '1x5'],
    'Press': ['2x5', '1x5', '1x3', '1x2', '5x3'],
    'Chin-Ups': ['3 sets to failure', '1st Set', '2nd Set', '3rd Set'],
    'Pull-Ups': ['3 sets to failure', '1st Set', '2nd Set', '3rd Set']
  };
  final workoutPlanRatio = {
    'Squat': [-45, 40, 60, 80, 100],
    'Front Squat': [-45, 40, 60, 80, 100],
    'Bench Press': [-45, 50, 70, 90, 100],
    'Power Clean': [-45, 55, 70, 85, 100],
    'Deadlift': [40, 60, 85, 100],
    'Press': [-45, 55, 70, 85, 100],
    'Chin-Ups': [0, 0, 0, 0],
    'Pull-Ups': [0, 0, 0, 0]
  };
  final workoutPrediction = (name, i) {
    if (name == 'Bench Press') return i % 2 == 1 ? true : false;
    if (name == 'Press') return i % 2 == 0 ? true : false;
    if (name == 'Deadlift') return i % 6 == 2 ? true : false;
    if (name == 'Power Clean') return i % 6 == 5 ? true : false;
    if (name == 'Chin-Ups') return false;
    if (name == 'Pull-Ups') return false;
    return true;
  };

  AdvancedNoviceProgram(a, b) : super(a, b);
}

// The factory class for the Novice Programs
class NLPFactory {
  // Returns the NLP object based on the name
  static NLPBase getNLP(String name, a, b) {
    switch (name) {
      case 'Original Novice Program':
        return OriginalNoviceProgram(a, b);
      case 'Practical Programming Novice Program':
        return PracticalProgrammingNoviceProgram(a, b);
      case 'Wichita Falls Novice Program':
        return WichitaFallsNoviceProgram(a, b);
      case 'Onus Wunsler Program':
        return OnusWunslerProgram(a, b);
      case 'Advanced Novice Program':
        return AdvancedNoviceProgram(a, b);
      default:
        return NLPBase(a, b);
    }
  }

// Returns the list of types for the NLP
  static List<String> getTypes(String name) {
    switch (name) {
      case 'Original Novice Program':
        return OriginalNoviceProgram.types;
      case 'Practical Programming Novice Program':
        return PracticalProgrammingNoviceProgram.types;
      case 'Wichita Falls Novice Program':
        return WichitaFallsNoviceProgram.types;
      case 'Onus Wunsler Program':
        return OnusWunslerProgram.types;
      case 'Advanced Novice Program':
        return AdvancedNoviceProgram.types;
      default:
        return NLPBase.types;
    }
  }

// Returns the workout options for the NLP
  static Map<String, List<int>> getDefaultWorkoutOptions(String name) {
    switch (name) {
      case 'Original Novice Program':
        return OriginalNoviceProgram.defaultWorkoutOptions;
      case 'Practical Programming Novice Program':
        return PracticalProgrammingNoviceProgram.defaultWorkoutOptions;
      case 'Wichita Falls Novice Program':
        return WichitaFallsNoviceProgram.defaultWorkoutOptions;
      case 'Onus Wunsler Program':
        return OnusWunslerProgram.defaultWorkoutOptions;
      case 'Advanced Novice Program':
        return AdvancedNoviceProgram.defaultWorkoutOptions;
      default:
        return NLPBase.defaultWorkoutOptions;
    }
  }

// Returns the default smallest weight increment for the NLP
  static int getDefaultSmallestWeightIncrement(String name) {
    switch (name) {
      case 'Original Novice Program':
        return OriginalNoviceProgram.defaultSmallestWeightIncrement;
      case 'Practical Programming Novice Program':
        return PracticalProgrammingNoviceProgram.defaultSmallestWeightIncrement;
      case 'Wichita Falls Novice Program':
        return WichitaFallsNoviceProgram.defaultSmallestWeightIncrement;
      case 'Onus Wunsler Program':
        return OnusWunslerProgram.defaultSmallestWeightIncrement;
      case 'Advanced Novice Program':
        return AdvancedNoviceProgram.defaultSmallestWeightIncrement;
      default:
        return NLPBase.defaultSmallestWeightIncrement;
    }
  }

// Returns the description of the workout options for the NLP
  static List<String> getWorkoutOptionDescriptions(String name) {
    switch (name) {
      case 'Advanced Novice Program':
        return AdvancedNoviceProgram.workoutOptionDescriptions;
      default:
        return NLPBase.workoutOptionDescriptions;
    }
  }
}
