import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_field/date_field.dart';
import 'package:gymapp/models/bmi.dart';
import 'package:gymapp/models/workout.dart';
import 'package:gymapp/services/exercise.dart';
import 'package:gymapp/services/inter.dart';
import 'package:gymapp/services/plan.dart';
import 'package:gymapp/services/training.dart';
import 'package:gymapp/utils/bmi_calculator.dart';
import 'package:gymapp/widgets/collapse_card.dart';

// The LogScreen class is used to display the log screen.
class LogScreen extends StatefulWidget {
  @override
  _LogScreenState createState() =>
      _LogScreenState(); // Return a _LogScreenState object.
}

// The _LogScreenState class is used to manage the state of the LogScreen class.
class _LogScreenState extends State<LogScreen> {
  final _formKey = GlobalKey<FormState>(); // Create a GlobalKey object.
  final _workoutController =
      TextEditingController(); // Create a TextEditingController object.
  final _weightController =
      TextEditingController(); // Create a TextEditingController object.
  final _setsController =
      TextEditingController(); // Create a TextEditingController object.
  final _repetitionController =
      TextEditingController(); // Create a TextEditingController object.
  final _heightController =
      TextEditingController(); // Create a TextEditingController object.
  final _bodyWeightController =
      TextEditingController(); // Create a TextEditingController object.
  final _setTypeController =
      TextEditingController(); // Create a TextEditingController object.
  final _resultController =
      TextEditingController(); // Create a TextEditingController object.
  DateTime _dateController = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day); // Create a DateTime object.
  List<Workout> _workouts = []; // Create a list of Workout objects.
  Function toggle = () {}; // Create a function.

  double _bmiCache = 0; // Create a double variable.

// The initState method is called when the state is initialized.
  _LogScreenState() {
    TrainingService.getLatestBMI().then((value) {
      // Call the getLatestBMI method.
      if (value != null) {
        _heightController.text = value.height
            .toStringAsFixed(2); // Set the text of the height controller.
        _bodyWeightController.text = value.weight
            .toStringAsFixed(2); // Set the text of the body weight controller.
        _bmiCache = value.bmi; // Set the value of the bmi cache.
      } else {
        _heightController.text =
            "180"; // Set the text of the height controller.
        _bodyWeightController.text =
            '80'; // Set the text of the body weight controller.
      }
    });
    InterService.getTodayWorkouts().then((value) {
      // Call the getAllWorkouts method.
      setState(() {
        _workouts = value; // Set the state of the workouts.
      });
    });

// Add a listener to the height controller.
    _heightController.addListener(() {
      if ((double.tryParse(_heightController.text) ?? 0) > 0 &&
          (double.tryParse(_bodyWeightController.text) ?? 0) > 0) {
        // If the height controller and the body weight controller are greater than 0.
        setState(() {
          _bmiCache = BMICalculator.calculateBMI(
              double.parse(_heightController.text).toInt(),
              double.parse(_bodyWeightController.text).toInt());
        }); // Set the state of the bmi cache.
      } else {
        setState(() {
          _bmiCache = 0;
        }); // Set the state of the bmi cache.
      }
    });

// Add a listener to the body weight controller.
    _bodyWeightController.addListener(() {
      if ((double.tryParse(_heightController.text) ?? 0) > 0 &&
          (double.tryParse(_bodyWeightController.text) ?? 0) > 0) {
        // If the height controller and the body weight controller are greater than 0.
        setState(() {
          _bmiCache = BMICalculator.calculateBMI(
              double.parse(_heightController.text).toInt(),
              double.parse(_bodyWeightController.text).toInt());
        }); // Set the state of the bmi cache.
      } else {
        setState(() {
          _bmiCache = 0;
        }); // Set the state of the bmi cache.
      }
    });

    _workoutController.text = 'Squat';
    _setTypeController.text = 'warmup';
    _resultController.text = 'success';
  }

// The build method is used to build the UI.
  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context).settings.arguments != null) {
      InterService.findNextUntrainedWorkout(
              ModalRoute.of(context).settings.arguments)
          .then((workout) {
        setState(() {
          _workoutController.text = workout.name;
          _weightController.text = workout.weight.toString();
          _setsController.text = workout.sets.toString();
          _repetitionController.text = workout.reps.toString();
          _setTypeController.text = workout.mode_type;
        });
      });
    }

    return Scaffold(
      // Return a Scaffold object.
      appBar: AppBar(
        title: Text('Log'),
      ),
      body: SingleChildScrollView(
        // Return a SingleChildScrollView object.
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Set the padding.
          child: Form(
            key: _formKey, // Set the key of the form.
            child: Column(
              children: <Widget>[
                ExpandableCard(
                  'Planned Exercises',
                  '${_workouts.length} planned workouts today',
                  Column(
                    children: [
                      for (var workout in _workouts)
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                                    '${workout.name} ${workout.sets}x${workout.reps} ${workout.weight}kg, ${workout.mode_type}')),
                            // If it is finished, show a check icon.
                            if (workout.id < 0) Icon(Icons.check),
                            // A button to apply the workout to the log.
                            ElevatedButton(
                              child: Text('Fill'),
                              onPressed: () {
                                setState(() {
                                  _workoutController.text = workout.name;
                                  _weightController.text =
                                      workout.weight.toString();
                                  _setsController.text =
                                      workout.sets.toString();
                                  _repetitionController.text =
                                      workout.reps.toString();
                                  _setTypeController.text = workout.mode_type;
                                });
                                toggle();
                              },
                            ),
                          ],
                        )
                    ],
                  ),
                  toggleFn: (fn) {
                    toggle = fn;
                  },
                ),
                // A drop-down menu to select the workout.
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Workout'),
                  items: ExerciseService.exercises
                      .map((workout) => DropdownMenuItem(
                            child: Text(workout.name),
                            value: workout.name,
                          ))
                      .toList(),
                  value: _workoutController.text.length > 0
                      ? _workoutController.text
                      : 'Squat',
                  onChanged: (value) {
                    setState(() {
                      _workoutController.text = value;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please select a workout';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.numberWithOptions(),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(labelText: 'Weight'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter weight';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _setsController,
                  keyboardType: TextInputType.numberWithOptions(),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(labelText: 'Sets'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter sets';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _repetitionController,
                  keyboardType: TextInputType.numberWithOptions(),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(labelText: 'Repetitions'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter repetitions';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Set type'),
                  items: [
                    DropdownMenuItem(
                      child: Text("warmup"),
                      value: "warmup",
                    ),
                    DropdownMenuItem(
                      child: Text("working set"),
                      value: "working sets",
                    )
                  ],
                  value: _setTypeController.text.length > 0
                      ? _setTypeController.text
                      : 'warmup',
                  onChanged: (value) {
                    setState(() {
                      _setTypeController.text = value;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please select a type';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Result'),
                  items: [
                    DropdownMenuItem(
                      child: Text("success"),
                      value: "success",
                    ),
                    DropdownMenuItem(
                      child: Text("failure"),
                      value: "failure",
                    )
                  ],
                  value: _resultController.text.length > 0
                      ? _resultController.text
                      : 'success',
                  onChanged: (value) {
                    setState(() {
                      _resultController.text = value;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please select a type';
                    }
                    return null;
                  },
                ),

                // a date picker to select the date.
                DateTimeField(
                  decoration: InputDecoration(labelText: 'Date'),
                  mode: DateTimeFieldPickerMode.date,
                  selectedDate: _dateController,
                  onDateSelected: (DateTime date) {
                    setState(() {
                      _dateController = date;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text("Body Metrics"),
                TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  decoration: InputDecoration(labelText: 'Height (cm)'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your height';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _bodyWeightController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  decoration: InputDecoration(labelText: 'Weight (kg)'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(_bmiCache > 0
                    ? ('Your current BMI is ${_bmiCache.toStringAsFixed(2)}')
                    : ''),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // When the button is pressed.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid.
                      // save workout and body metrics
                      TrainingService.saveWorkout(Workout(
                          name: _workoutController.text,
                          date: _dateController,
                          weight: int.parse(_weightController.text),
                          sets: int.parse(_setsController.text),
                          reps: int.parse(_repetitionController.text),
                          mode_type: _setTypeController.text,
                          result: _resultController.text));
                      TrainingService.saveBMI(BMI(
                          bmi: BMICalculator.calculateBMI(
                              double.parse(_heightController.text).toInt(),
                              double.parse(_bodyWeightController.text).toInt()),
                          height: double.parse(_heightController.text),
                          weight: double.parse(_bodyWeightController.text),
                          date: _dateController));

                      // Clear the text fields.
                      _workoutController.text = '';
                      _weightController.clear();
                      _setsController.clear();
                      _repetitionController.clear();
                      // _heightController.clear();
                      // _bodyWeightController.clear();

                      InterService.getTodayWorkouts().then((value) {
                        // Call the getAllWorkouts method.
                        setState(() {
                          _workouts = value; // Set the state of the workouts.
                        });
                      });

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Workout and Body metrics are saved!'))); // Show a snackbar.
                    }
                  },
                  child: Text('Save'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // When the button is pressed.
                    // show workout history
                    TrainingService.getAllWorkouts().then((value) {
                      // Sort value first by date and then by id
                      value.sort((a, b) => b.date.compareTo(a.date) == 0
                          ? b.id.compareTo(a.id)
                          : b.date.compareTo(a.date));
                      TrainingService.getAllBMI().then((bmi) {
                        bmi.sort((a, b) => b.date.compareTo(a.date));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkoutHistory(value, bmi)),
                        ); // Navigate to the second screen using a named route.
                      });
                    });
                  },
                  child: Text('Show History'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// the workout history page
class WorkoutHistory extends StatelessWidget {
  final List<Workout> workouts; // the list of workouts
  final List<BMI> bmi; // the list of bmi

  WorkoutHistory(this.workouts, this.bmi); // constructor

  BMI findBMIForWorkout(Workout w) {
    // Find the BMI that the date is closest to the workout date
    BMI closestBMI;
    for (BMI b in bmi) {
      if (closestBMI == null) {
        closestBMI = b;
      } else {
        if ((w.date.difference(b.date).inDays).abs() <
            (w.date.difference(closestBMI.date).inDays).abs()) {
          closestBMI = b;
        }
      }
    }
    return closestBMI;
  }

// build the page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout History'),
      ),
      body: ListView.builder(
        // use a list view to display the workouts
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          // swipe the item to delete
          return Dismissible(
              key: Key(workouts[index].name),
              onDismissed: (direction) {
                // remove the workout from the database
                TrainingService.deleteWorkout(workouts[index].id);
                TrainingService.deleteBMI(
                    findBMIForWorkout(workouts[index]).id);
                // remove the workout from the list
                workouts.removeAt(index);
                // show a snackbar
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Workout is removed!'))); // Show a snackbar.
              },
              background: Container(color: Colors.red),
              child: ListTile(
                // each list item is a workout
                title: Text(
                    workouts[index].name + ' - ' + workouts[index].mode_type,
                    style: TextStyle(
                        color: workouts[index].result == 'success'
                            ? Colors.green
                            : Colors.red)),
                // Show icon of success or failure
                leading: Icon(
                    workouts[index].result == 'success'
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: workouts[index].result == 'success'
                        ? Colors.green
                        : Colors.red),
                subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'weight: ${workouts[index].weight.toString()}, reps: ${workouts[index].reps.toString()}, sets: ${workouts[index].sets.toString()}'),
                      Text(
                          'BMI: ${findBMIForWorkout(workouts[index]).bmi.toStringAsFixed(2)}, height: ${findBMIForWorkout(workouts[index]).height.toStringAsFixed(0)}, weight: ${findBMIForWorkout(workouts[index]).weight.toStringAsFixed(0)}')
                    ]),
                trailing: Text(
                    '${workouts[index].date.year}-${workouts[index].date.month}-${workouts[index].date.day}'),
              ));
        },
      ),
    );
  }
}
