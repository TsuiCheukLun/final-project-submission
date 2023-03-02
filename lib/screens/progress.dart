import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gymapp/models/bmi.dart';
import 'package:gymapp/models/workout.dart';
import 'package:gymapp/services/exercise.dart';
import 'package:gymapp/services/training.dart';
import 'package:gymapp/utils/converter.dart';
import 'package:table_calendar/table_calendar.dart';

// The ProgressScreen class is used to display the progress screen.
class ProgressScreen extends StatefulWidget {
  final RouteObserver<PageRoute> routeObserver;
  ProgressScreen(this.routeObserver);

  @override
  _ProgressScreenState createState() =>
      _ProgressScreenState(); // Return a _ProgressScreenState widget.
}

// The _ProgressScreenState class is used to display the progress screen.
class _ProgressScreenState extends State<ProgressScreen> with RouteAware {
  _ProgressScreenViewModel
      _viewModel; // Create a _ProgressScreenViewModel object.
  bool _animate; // Create a bool object.
  int _ready; // Create a bool object.
  String _mode; // Create a String object.

  // The didChangeDependencies method is called when the state of the widget changes.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context));
  }

// The dispose method is called when the widget is disposed.
  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    super.dispose();
  }

// The didPopNext method is called when the widget is popped.
  @override
  void didPopNext() {
    setState(() {
      _ready = 0;
      _mode = 'overview';
      _viewModel = _ProgressScreenViewModel();
      _viewModel.onReady(() {
        setState(() {
          _ready++;
        });
      }); // Call the onReady method.
    });
  }

// The initState method is used to initialize the state of the widget.
  @override
  void initState() {
    super.initState(); // Call the super class method.
    _ready = 0;
    _mode = 'overview';
    _viewModel = _ProgressScreenViewModel();
    _viewModel.onReady(() {
      setState(() {
        _ready++;
      });
    }); // Call the onReady method.

    _animate = true;
  }

// The build method builds the widget.
  @override
  Widget build(BuildContext context) {
    if (_ready <= 0) {
      // If the _ready bool is false, return a Scaffold widget.
      return Scaffold(
        appBar: AppBar(
          title: Text('Progress'),
        ),
        body: Center(
            child: Column(
          children: [
            Text('No data to display'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, '/log'); // Navigate to the log screen.
              },
              child: Text('Log new training'),
            ),
          ],
        )),
      );
    }
    // Return a Scaffold widget.
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            // create several buttons to switch between the different modes, includes overview, and exercises in exercise service.
            // the row will be auto-wrap if the buttons are too many
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 8.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _mode = 'overview';
                      });
                    },
                    child: Text('Overview'),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _mode = 'bmi';
                      });
                    },
                    child: Text('BMI'),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  // map each exercise to a button and a sizedbox
                  ...ExerciseService.exercises
                      .where((element) =>
                          _viewModel._workoutData.firstWhere(
                              (e) => e.name == element.name,
                              orElse: () => null) !=
                          null)
                      .map((exercise) {
                    return [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _mode = exercise.name;
                          });
                        },
                        child: Text(exercise.name),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                    ];
                  }).expand((x) => x),
                  SizedBox(
                    width: 8.0,
                  ),
                ],
              ),
            ),
            if (_mode == 'overview') ...[
              _viewModel._calendar,
              Text('Workout Weight Progress'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: charts.BarChart(
                    _viewModel
                        ._createSampleWeightDataOnDate(_viewModel._selectedDay),
                    animate: _animate,
                  ),
                ),
              ),
            ],
            if (_mode == 'bmi') ...[
              Text('BMI Progress'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: charts.TimeSeriesChart(
                    _viewModel.createBMI(),
                    animate: _animate,
                  ),
                ),
              ),
              Text('Weight Progress'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: charts.TimeSeriesChart(
                    _viewModel.createWeight(),
                    animate: _animate,
                  ),
                ),
              ),
              Text('Height Progress'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: charts.TimeSeriesChart(
                    _viewModel.createHeight(),
                    animate: _animate,
                  ),
                ),
              ),
            ],
            if (_mode != 'overview' && _mode != 'bmi') ...[
              Text('$_mode Weight Progress'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: charts.TimeSeriesChart(
                    _viewModel.createSampleDataWithType(_mode, 'weight'),
                    animate: _animate,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// The _ProgressScreenViewModel class is used to display the progress screen.
class _ProgressScreenViewModel {
  List<Workout> _workoutRawData; // Create a List<Workout> object.
  List<Workout> _workoutData; // Create a List<Workout> object.
  List<charts.Series<Workout, String>>
      _seriesList; // Create a List<charts.Series<Workout, String>> object.

  TableCalendar _calendar; // the calendar widget
  DateTime _selectedDay; // the selected day

  List<charts.Series<Workout, String>>
      _seriesSetsList; // Create a List<charts.Series<Workout, String>> object.
  List<charts.Series<Workout, String>>
      _seriesRepsList; // Create a List<charts.Series<Workout, String>> object.
  Function _callback = null; // Create a Function object.
  List<BMI> _bmiData; // Create a List<BMI> object.

  List<charts.Series<Workout, String>> get seriesList {
    return _seriesList;
  } // Return the _seriesList object.

  List<charts.Series<Workout, String>> get seriesSetsList {
    return _seriesSetsList;
  } // Return the _seriesSetsList object.

  List<charts.Series<Workout, String>> get seriesRepsList {
    return _seriesRepsList;
  } // Return the _seriesRepsList object.

// The _ProgressScreenViewModel constructor is used to initialize the _ProgressScreenViewModel object.
  _ProgressScreenViewModel() {
    _workoutRawData = [];
    _workoutData = [];
    _seriesList = [];
    _seriesRepsList = [];
    _seriesSetsList = [];
    _bmiData = [];

    _selectedDay = DateTime.utc(DateTime.now().year, DateTime.now().month,
        DateTime.now().day); // set the selected day to the today
    _calendar = TableCalendar(
      onDaySelected: _onDaySelected,
      focusedDay: _selectedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      firstDay: DateTime.utc(2023, 1, 1),
      lastDay: _selectedDay,
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
      ),
    ); // create the calendar widget
    _getWorkoutData().then((value) {
      _workoutData = value;
      _seriesList = _createSampleWeightData();
      _seriesSetsList = _createSampleSetsData();
      _seriesRepsList = _createSampleRepsData();
      if (_workoutData.length > 0 && _callback != null) _callback();
    }); // Call the _getWorkoutData method.
  }

// The onReady method is used to check if the _workoutData object is empty.
  void onReady(callback) {
    if (_workoutData.length <= 0) {
      _callback = callback;
      return;
    }
    callback();
  }

  // function to handle when a day is selected
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay = focusedDay;
    _calendar = TableCalendar(
      onDaySelected: _onDaySelected,
      focusedDay: _selectedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      firstDay: _calendar.firstDay,
      lastDay: _calendar.lastDay,
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        formatButtonVisible: false, // hide the format button
      ),
    ); // create the calendar widget
    if (_callback != null) {
      _callback();
    }
  }

// The _getWorkoutData method is used to get the workout data.
  Future<List<Workout>> _getWorkoutData() async {
    // get workout data from local database or API
    List<Workout> workouts = (await TrainingService.getAllWorkouts())
        .where((element) =>
            element.mode_type == 'working sets' && element.result == 'success')
        .toList();

    workouts.sort((a, b) => a.date.compareTo(b.date));
    _bmiData = await TrainingService.getAllBMI();
    _workoutRawData = workouts;
    // Aggregate data based on workout name
    Map<String, Map<String, dynamic>> workoutMap = {};
    workouts.forEach((workout) {
      if (workoutMap.containsKey(workout.name)) {
        // If the workoutMap object contains the workout name, add the workout weight, sets, and reps.
        workoutMap[workout.name]['weight'] = max(
            workout.weight,
            workoutMap[workout.name]['weight']
                as int); // Get the maximum value between the workout weight and the workoutMap weight.
        workoutMap[workout.name]['sets'] = max(
            workout.sets,
            workoutMap[workout.name]['sets']
                as int); // Get the maximum value between the workout sets and the workoutMap sets.
        workoutMap[workout.name]['reps'] = max(
            workout.reps,
            workoutMap[workout.name]['reps']
                as int); // Get the maximum value between the workout reps and the workoutMap reps.
      } else {
        workoutMap[workout.name] = WorkoutConverter.toMap(workout);
      }
    }); // Loop through the workouts object.
    return workoutMap.values
        .map((workout) => WorkoutConverter.fromMap(workout))
        .toList(); // Return the workoutMap object.
  }

// The _createSampleWeightData method is used to create the sample weight data.
  List<charts.Series<Workout, String>> _createSampleWeightData() {
    return [
      charts.Series<Workout, String>(
        id: 'Workout Progress',
        data: _workoutData,
        domainFn: (Workout data, _) => data.name,
        measureFn: (Workout data, _) => data.weight,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];
  }

  // The _createSampleWeightDataOnDate method is used to create the sample weight data on the given date
  List<charts.Series<Workout, String>> _createSampleWeightDataOnDate(
      DateTime date) {
    // Only keep the first workout of the day
    List<String> workoutNames = [];
    List<Workout> workoutData = _workoutRawData
        .where((element) => isSameDay(element.date, date))
        .where((element) {
      if (workoutNames.contains(element.name)) {
        return false;
      } else {
        workoutNames.add(element.name);
        return true;
      }
    }).toList();
    return [
      charts.Series<Workout, String>(
        id: 'Workout Progress',
        data: workoutData,
        domainFn: (Workout data, _) => data.name,
        measureFn: (Workout data, _) => data.weight,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];
  }

// The _createSampleSetsData method is used to create the sample sets data.
  List<charts.Series<Workout, String>> _createSampleSetsData() {
    return [
      charts.Series<Workout, String>(
        id: 'Workout Progress',
        data: _workoutData,
        domainFn: (Workout data, _) => data.name,
        measureFn: (Workout data, _) => data.sets,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
      )
    ];
  }

// The _createSampleRepsData method is used to create the sample reps data.
  List<charts.Series<Workout, String>> _createSampleRepsData() {
    return [
      charts.Series<Workout, String>(
        id: 'Workout Progress',
        data: _workoutData,
        domainFn: (Workout data, _) => data.name,
        measureFn: (Workout data, _) => data.reps,
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
      )
    ];
  }

  // The createSampleDataWithType method is used to create the sample data with type.
  List<charts.Series<Workout, DateTime>> createSampleDataWithType(
      String name, String type) {
    List<DateTime> dates = [];
    return [
      charts.Series<Workout, DateTime>(
        id: 'Workout Progress',
        data: _workoutRawData
            .where((element) => element.name == name)
            .where((element) {
          // Only keep the first element in a day
          if (dates.contains(element.date)) {
            return false;
          } else {
            dates.add(element.date);
            return true;
          }
        }).toList(),
        domainFn: (Workout data, _) => data.date,
        measureFn: (Workout data, _) {
          switch (type) {
            case 'weight':
              return data.weight;
            case 'sets':
              return data.sets;
            case 'reps':
              return data.reps;
            default:
              return data.weight;
          }
        },
        colorFn: (_, __) {
          switch (type) {
            case 'weight':
              return charts.MaterialPalette.blue.shadeDefault;
            case 'sets':
              return charts.MaterialPalette.green.shadeDefault;
            case 'reps':
              return charts.MaterialPalette.deepOrange.shadeDefault;
            default:
              return charts.MaterialPalette.blue.shadeDefault;
          }
        },
      )
    ];
  }

  // The createBMI method is used to create the sample data for the BMI.
  List<charts.Series<BMI, DateTime>> createBMI() {
    return [
      charts.Series<BMI, DateTime>(
        id: 'BMI',
        data: _bmiData,
        domainFn: (BMI data, _) => data.date,
        measureFn: (BMI data, _) => data.bmi,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];
  }

  // The createWeight method is used to create the sample data for the weight.
  List<charts.Series<BMI, DateTime>> createWeight() {
    return [
      charts.Series<BMI, DateTime>(
        id: 'Weight',
        data: _bmiData,
        domainFn: (BMI data, _) => data.date,
        measureFn: (BMI data, _) => data.weight,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];
  }

  // The createHeight method is used to create the sample data for the height.
  List<charts.Series<BMI, DateTime>> createHeight() {
    return [
      charts.Series<BMI, DateTime>(
        id: 'Height',
        data: _bmiData,
        domainFn: (BMI data, _) => data.date,
        measureFn: (BMI data, _) => data.height,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];
  }
}
