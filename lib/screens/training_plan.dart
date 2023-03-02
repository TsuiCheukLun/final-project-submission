import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymapp/models/workout.dart';
import 'package:gymapp/services/plan.dart';
import 'package:gymapp/utils/reminder.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gymapp/utils/novice_linear_program.dart';
import 'package:gymapp/widgets/collapse_card.dart';

// The TrainingPlanScreen class is used to display the training plan screen.
class TrainingPlanScreen extends StatefulWidget {
  @override
  _TrainingPlanScreenState createState() =>
      _TrainingPlanScreenState(); // Return a _TrainingPlanScreenState widget.
}

// The _TrainingPlanScreenState class is used to display the training plan screen.
class _TrainingPlanScreenState extends State<TrainingPlanScreen> {
  TrainingPlanViewModel _viewModel; // Create a TrainingPlanViewModel object.
  int _updateFlag = 0; // Create an int object.

// The initState method is used to initialize the state of the widget.
  @override
  void initState() {
    super.initState(); // Call the super class method.
    _viewModel = TrainingPlanViewModel(() => setState(
        () => _updateFlag++)); // Call the TrainingPlanViewModel constructor.
    _viewModel.loadTrainingData(); // Call the loadTrainingData method.
  }

// The build method builds the widget.
  @override
  Widget build(BuildContext context) {
    if (_updateFlag < 0) return Container(); // to avoid warning
    return Scaffold(
      // Return a Scaffold widget.
      appBar: AppBar(
        title: Text('Training Plan'),
      ),
      body: SingleChildScrollView(
        // Return a SingleChildScrollView widget.
        child: Column(
          children: <Widget>[
            _viewModel.calendar,
            _viewModel.buildStatistics(context),
            SizedBox(height: 20),
            // create a heading text
            Text('NLP calculator', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            // Create 5 cards that each shows Original Novice Program, Practical Programming Novice Program, Wichita Falls Novice Program, Onus Wunsler Program and Advanced Novice Program
            // Each card should have a title, a description and a button that says "Start Training"
            // When the button is pressed, the user should be navigated to the training screen
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Original Novice Program'),
                    subtitle: Text(
                        'The original novice program is a 2 day per week program that focuses on building a foundation of strength and muscle mass.'),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      TextButton(
                        child: const Text('Start Training'),
                        onPressed: () {
                          // Navigate to the TrainingPlanDetailScreen class
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TrainingPlanDetailScreen(
                                  'Original Novice Program', _viewModel),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Practical Programming Novice Program'),
                    subtitle: Text(
                        'The practical programming novice program is a 3 day per week program that focuses on building a foundation of strength and muscle mass.'),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      TextButton(
                        child: const Text('Start Training'),
                        onPressed: () {
                          /* ... */
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TrainingPlanDetailScreen(
                                  'Practical Programming Novice Program',
                                  _viewModel),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Wichita Falls Novice Program'),
                    subtitle: Text(
                        'The Wichita Falls novice program is a 3 day per week program that focuses on building a foundation of strength and muscle mass.'),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      TextButton(
                        child: const Text('Start Training'),
                        onPressed: () {
                          /* ... */
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TrainingPlanDetailScreen(
                                  'Wichita Falls Novice Program', _viewModel),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Onus Wunsler Program'),
                    subtitle: Text(
                        'The Onus Wunsler program is a 2 day per week program that focuses on building a foundation of strength and muscle mass.'),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      TextButton(
                        child: const Text('Start Training'),
                        onPressed: () {
                          /* ... */
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TrainingPlanDetailScreen(
                                  'Onus Wunsler Program', _viewModel),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Advanced Novice Program'),
                    subtitle: Text(
                        'The advanced novice program is a 3 day per week program that focuses on building a foundation of strength and muscle mass.'),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      TextButton(
                        child: const Text('Start Training'),
                        onPressed: () {
                          /* ... */
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TrainingPlanDetailScreen(
                                  'Advanced Novice Program', _viewModel),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // create a heading text
            Text('How to start NLP training', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            // Create a list of steps that the user should follow to start NLP training
            Text(
                "1. Determine your goals: The first step to starting an NLP training program is to determine what you want to achieve. Are you looking to build muscle, increase strength, or improve your overall fitness? This will help you to select the right exercises and set realistic goals."),
            SizedBox(height: 10),
            Text(
                "2. Create a plan: Once you know your goals, you can create a plan to achieve them. This will involve selecting exercises that target the specific muscles you want to work on, and scheduling them into your training program. A well-rounded program should include exercises for the major muscle groups such as the chest, back, legs, and core."),
            SizedBox(height: 10),
            Text(
                "3. Start with a beginner program: If you are new to NLP training, it is important to start with a beginner program to avoid injury. A beginner program should include exercises that are easy to perform with proper form and focus on building a foundation of strength."),
            SizedBox(height: 10),
            Text(
                "4. Focus on progressive overload: Progressive overload is the gradual increase of stress placed on the body during exercise. This is important for building muscle and strength. To achieve progressive overload, you can increase the weight, reps, or sets of an exercise or reduce the rest time between sets."),
            SizedBox(height: 10),
            Text(
                "5. Incorporate variety: To avoid boredom and plateaus, it's important to incorporate variety into your training program. This can include switching up exercises, using different equipment, or changing the order of exercises."),
            SizedBox(height: 10),
            Text(
                "6. Get enough rest: NLP training puts a lot of stress on the body and it is important to allow enough time for rest and recovery. This means getting enough sleep, and allowing time for muscle recovery between workout sessions."),
            SizedBox(height: 10),
            Text(
                "7. Keep track of your progress: Keeping track of your progress can help you to stay motivated and see the results of your hard work. This can be done by taking measurements, tracking your weight, and keeping a workout log."),
            SizedBox(height: 10),
            Text(
                "8. Be consistent: Consistency is key to achieving results in NLP training. Stick to your plan and make sure to train regularly."),
            SizedBox(height: 10),
            Text(
                "9. Seek professional help if needed: If you are unsure about your training program or have any health concerns, it is best to seek professional help from a personal trainer or physical therapist. They can help you to develop a safe and effective program that is tailored to your needs and goals."),
          ],
        ),
      ),
    );
  }
}

// the view model for the training plan screen
class TrainingPlanViewModel {
  Map<DateTime, List<Workout>> _events; // the events for the calendar
  TableCalendar _calendar; // the calendar widget
  DateTime _selectedDay; // the selected day
  List<Workout> _selectedEvents; // the events for the selected day
  Function _update; // the function to update the view

  get calendar {
    return _calendar;
  } // getter for the calendar

// getter for the selected day
  TrainingPlanViewModel(this._update) {
    _selectedDay = DateTime.utc(DateTime.now().year, DateTime.now().month,
        DateTime.now().day); // set the selected day to the today
    _selectedEvents = []; // set the selected events to an empty list
    _calendar = TableCalendar(
      onDaySelected: _onDaySelected,
      focusedDay: _selectedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      firstDay: _selectedDay,
      lastDay: _selectedDay,
      eventLoader: _getEventsForDay,
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
      ),
    ); // create the calendar widget
  }

// function to get the events for a given day
  void loadTrainingData() {
    _events = {}; // set the events to an empty map
    PlanService.getAllWorkouts().then((value) {
      // get all the workouts from the database
      _events = {};
      value.forEach((element) {
        DateTime normalizedDate = DateTime.utc(element.date.year,
            element.date.month, element.date.day); // normalize the date
        if (_events[normalizedDate] == null)
          _events[normalizedDate] =
              []; // create a new list for the date if it doesn't exist
        _events[normalizedDate].add(element); // add the workout to the list
      }); // add the workouts to the events map
      List<DateTime> days = _events.keys.toList(); // get the list of days
      days.sort((a, b) => a.compareTo(b)); // sort the days
      if (days.length > 0) {
        DateTime today = DateTime.utc(DateTime.now().year, DateTime.now().month,
            DateTime.now().day); // get today's date
        // check if today is in range of days.first and days.last
        if (days.first.isBefore(today) && days.last.isAfter(today)) {
          _selectedDay = today; // set the selected day to today
        } else {
          _selectedDay = days.first; // set the selected day to the first day
        }
        _selectedEvents =
            _events[_selectedDay] ?? []; // get the events for the selected day
        _calendar = TableCalendar(
          onDaySelected: _onDaySelected,
          focusedDay: _selectedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          firstDay:
              DateTime.utc(days.first.year, days.first.month, days.first.day),
          lastDay: DateTime.utc(days.last.year, days.last.month, days.last.day),
          eventLoader: _getEventsForDay,
          calendarFormat: CalendarFormat.month,
          headerStyle: HeaderStyle(
            formatButtonVisible: false, // hide the format button
          ),
        ); // create the calendar widget
        _update(); // update the view
      } else {
        _selectedDay = DateTime.utc(DateTime.now().year, DateTime.now().month,
            DateTime.now().day); // set the selected day to today
        _selectedEvents = []; // set the selected events to an empty list
        _calendar = TableCalendar(
          onDaySelected: _onDaySelected,
          focusedDay: _selectedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          firstDay: _selectedDay,
          lastDay: _selectedDay,
          eventLoader: _getEventsForDay,
          calendarFormat: CalendarFormat.month,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
          ),
        ); // create the calendar widget
        _update(); // update the view
      }
    });
  }

// function to handle when a day is selected
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay = focusedDay;
    _selectedEvents = _events[focusedDay] ?? [];
    _calendar = TableCalendar(
      onDaySelected: _onDaySelected,
      focusedDay: _selectedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      firstDay: _calendar.firstDay,
      lastDay: _calendar.lastDay,
      eventLoader: _getEventsForDay,
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        formatButtonVisible: false, // hide the format button
      ),
    ); // create the calendar widget
    _update();
  }

// function to get the events for a given day
  List _getEventsForDay(DateTime day) {
    if (day == null) {
      return [];
    }
    if (_events[day] == null || _events[day].length == 0) {
      return [];
    }
    return [1]; // only return one event for each day
  }

  // function to show the workout as table
  Widget showWorkoutTable() {
    // Aggregate the workout for the selected day by its name
    Map<String, List<Workout>> workoutMap = {};
    int maxColumns = 0;
    _selectedEvents.forEach((element) {
      if (workoutMap[element.name] == null) {
        workoutMap[element.name] = [];
      }
      workoutMap[element.name].add(element);
      if (workoutMap[element.name].length > maxColumns) {
        maxColumns = workoutMap[element.name].length;
      }
    });

    return Row(children: [
      for (int i = 0; i < maxColumns + 1; i++)
        Column(
          children: [
            for (String key in workoutMap.keys)
              if (i == 0)
                Column(
                  children: [Text(''), Text(key), Text('')],
                )
              else
                Column(
                  children: [
                    Text(workoutMap[key].length >= i
                        ? workoutMap[key][i - 1].mode_type + ' '
                        : ''),
                    Text(workoutMap[key].length >= i
                        ? workoutMap[key][i - 1].sets.toString() +
                            ' x ' +
                            workoutMap[key][i - 1].reps.toString()
                        : ''),
                    Text(workoutMap[key].length >= i
                        ? workoutMap[key][i - 1].weight.toString()
                        : ''),
                  ],
                )
          ],
        )
    ]);
  }

// function to build the statistics widget
  Widget buildStatistics(BuildContext context) {
    // Display statistical information about selected day's training
    if (_selectedEvents.length == 0) return Text('No training on this day');
    return Column(
      children: [
        // Add a button to add to reminder
        ElevatedButton(
          onPressed: () {
            // Check if is today
            if (DateTime.now().year == _selectedDay.year &&
                DateTime.now().month == _selectedDay.month &&
                DateTime.now().day == _selectedDay.day) {
              // Add to reminder
              scheduleReminder(DateTime.now(), 'Time to workout!');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('You will be notified soon!'),
              ));
            } else {
              // Add to reminder, 9 AM
              scheduleReminder(
                  _selectedDay.add(Duration(hours: 9)), 'Time to workout!');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('You will be notified at 9AM!'),
              ));
            }
          },
          child: Text('Add to reminder'),
        ),
        // Display the total number of exercises
        Text('Total exercises: ' + _selectedEvents.length.toString()),
        // Show all training details
        showWorkoutTable()
      ],
    );
  }
}

// the training plan screen
class TrainingPlanDetailScreen extends StatefulWidget {
  final String _program; // the training program
  final TrainingPlanViewModel _viewModel; // the view model
  TrainingPlanDetailScreen(this._program, this._viewModel); // constructor

  @override
  _TrainingPlanDetailScreenState createState() =>
      _TrainingPlanDetailScreenState(); // create the state
}

// the state for the training plan screen
class _TrainingPlanDetailScreenState extends State<TrainingPlanDetailScreen> {
  final _incController =
      TextEditingController(); // the controller for the increment
  Widget _widget; // the widget for the training plan
  int _inc; // the increment
  Map<String, List<int>> _workoutOptions; // the workout options
  Map<String, bool> _daysOfWeek; // the days of the week
  DateTime _startDate; // the start date

// function to init the view
  @override
  void initState() {
    super.initState();
    _incController.value =
        TextEditingValue(text: '5'); // set the increment to 5
    _inc = NLPFactory.getDefaultSmallestWeightIncrement(
        widget._program); // get the default increment
    _workoutOptions = NLPFactory.getDefaultWorkoutOptions(
        widget._program); // get the default workout options
    _widget = NLPFactory.getNLP(
            widget._program,
            NLPFactory.getDefaultSmallestWeightIncrement(widget._program),
            NLPFactory.getDefaultWorkoutOptions(widget._program))
        .getWorkoutPlanWidget(); // get the workout plan widget
    _daysOfWeek = {
      'Monday': false,
      'Tuesday': false,
      'Wednesday': false,
      'Thursday': false,
      'Friday': false,
      'Saturday': false,
      'Sunday': false
    }; // set the days of the week to false
    _startDate = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day); // set the start date to now
    // get the workout plan from nlp
    var workoutPlans = NLPFactory.getNLP(widget._program, _inc, _workoutOptions)
        .workoutPlanOrder;
    if (workoutPlans.length == 2) {
      // set Tuesday and Thursday to true
      _daysOfWeek['Tuesday'] = true;
      _daysOfWeek['Thursday'] = true;
    }
    if (workoutPlans.length == 3) {
      // set Monday, Wednesday, and Friday to true
      _daysOfWeek['Monday'] = true;
      _daysOfWeek['Wednesday'] = true;
      _daysOfWeek['Friday'] = true;
    }
  }

// function to dispose of the view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // create the scaffold
        appBar: AppBar(
          title: Text('Training Plan'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Text('Config', style: TextStyle(fontSize: 20)),
            ExpandableCard(
                'Date Setting',
                '',
                Column(
                  children: [
                    // Select the start date of the training plan
                    Text('Start Date'),
                    DateTimeField(
                      mode: DateTimeFieldPickerMode.date,
                      onDateSelected: (date) {
                        setState(() {
                          _startDate = date; // set the start date
                        });
                      },
                      selectedDate: _startDate,
                    ),
                    SizedBox(height: 10),
                    // Select the training days of the week
                    Text('Training Days'),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Checkbox(
                            value: _daysOfWeek[
                                'Monday'], // get the value of the day
                            onChanged: (value) {
                              setState(() {
                                _daysOfWeek['Monday'] =
                                    value; // set the day to its value
                              });
                            },
                          ),
                          Text('Mon'),
                          SizedBox(width: 10),
                          Checkbox(
                            value: _daysOfWeek[
                                'Tuesday'], // get the value of the day
                            onChanged: (value) {
                              setState(() {
                                _daysOfWeek['Tuesday'] =
                                    value; // set the day to its value
                              });
                            },
                          ),
                          Text('Tue'),
                          SizedBox(width: 10),
                          Checkbox(
                            value: _daysOfWeek[
                                'Wednesday'], // get the value of the day
                            onChanged: (value) {
                              setState(() {
                                _daysOfWeek['Wednesday'] =
                                    value; // set the day to its value
                              });
                            },
                          ),
                          Text('Wed'),
                          SizedBox(width: 10),
                          Checkbox(
                            value: _daysOfWeek[
                                'Thursday'], // get the value of the day
                            onChanged: (value) {
                              setState(() {
                                _daysOfWeek['Thursday'] =
                                    value; // set the day to its value
                              });
                            },
                          ),
                          Text('Thu'),
                          SizedBox(width: 10),
                          Checkbox(
                            value: _daysOfWeek[
                                'Friday'], // get the value of the day
                            onChanged: (value) {
                              setState(() {
                                _daysOfWeek['Friday'] =
                                    value; // set the day to its value
                              });
                            },
                          ),
                          Text('Fri'),
                          SizedBox(width: 10),
                          Checkbox(
                            value: _daysOfWeek[
                                'Saturday'], // get the value of the day
                            onChanged: (value) {
                              setState(() {
                                _daysOfWeek['Saturday'] =
                                    value; // set the day to its value
                              });
                            },
                          ),
                          Text('Sat'),
                          SizedBox(width: 10),
                          Checkbox(
                            value: _daysOfWeek[
                                'Sunday'], // get the value of the day
                            onChanged: (value) {
                              setState(() {
                                _daysOfWeek['Sunday'] =
                                    value; // set the day to its value
                              });
                            },
                          ),
                          Text('Sun'),
                        ],
                      ),
                    )
                  ],
                )),
            ExpandableCard(
              // create the expandable card
              'Smallest Weight Increment',
              '',
              TextFormField(
                controller: _incController,
                keyboardType: TextInputType.numberWithOptions(),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration:
                    InputDecoration(labelText: 'Smallest Weight Increment'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _inc = int.parse(value);
                    _widget = NLPFactory.getNLP(
                            widget._program, int.parse(value), _workoutOptions)
                        .getWorkoutPlanWidget();
                  }); // update the view
                },
              ),
            ),
            for (String workout in _workoutOptions.keys) // for each workout
              ExpandableCard(
                workout,
                '',
                Column(
                  children: [
                    // four settings for each workout
                    TextFormField(
                      keyboardType: TextInputType.numberWithOptions(),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                          labelText: NLPFactory.getWorkoutOptionDescriptions(
                              workout)[0]),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                      initialValue: _workoutOptions[workout][0].toString(),
                      onChanged: (value) {
                        setState(() {
                          _workoutOptions[workout][0] = int.parse(value);
                          _widget = NLPFactory.getNLP(
                                  widget._program, _inc, _workoutOptions)
                              .getWorkoutPlanWidget();
                        });
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.numberWithOptions(),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                          labelText: NLPFactory.getWorkoutOptionDescriptions(
                              workout)[1]),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                      initialValue: _workoutOptions[workout][1].toString(),
                      onChanged: (value) {
                        setState(() {
                          _workoutOptions[workout][1] = int.parse(value);
                          _widget = NLPFactory.getNLP(
                                  widget._program, _inc, _workoutOptions)
                              .getWorkoutPlanWidget();
                        });
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.numberWithOptions(),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                          labelText: NLPFactory.getWorkoutOptionDescriptions(
                              workout)[2]),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                      initialValue: _workoutOptions[workout][2].toString(),
                      onChanged: (value) {
                        setState(() {
                          _workoutOptions[workout][2] = int.parse(value);
                          _widget = NLPFactory.getNLP(
                                  widget._program, _inc, _workoutOptions)
                              .getWorkoutPlanWidget();
                        });
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.numberWithOptions(),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                          labelText: NLPFactory.getWorkoutOptionDescriptions(
                              workout)[3]),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                      initialValue: _workoutOptions[workout][3].toString(),
                      onChanged: (value) {
                        setState(() {
                          _workoutOptions[workout][3] = int.parse(value);
                          _widget = NLPFactory.getNLP(
                                  widget._program, _inc, _workoutOptions)
                              .getWorkoutPlanWidget();
                        });
                      },
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
            Text('Suggested Workout Plan', style: TextStyle(fontSize: 20)),
            _widget, // display the workout plan
            SizedBox(height: 20),
            ElevatedButton(
              // create the button to save the plans
              child: Text('Add to calendar'),
              onPressed: () async {
                // check the _startDate is not past day
                if (_startDate
                    .isBefore(DateTime.now().subtract(Duration(days: 1)))) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Start date cannot be in the past'),
                  ));
                  return;
                }
                // check the _daysOfWeek should have 2 or 3 true only
                int count = 0;
                for (String day in _daysOfWeek.keys) {
                  if (_daysOfWeek[day]) {
                    count++;
                  }
                }
                if (count < 2 || count > 3) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please select 2 or 3 days in a week'),
                  ));
                  return;
                }

                // Cool Down Period (48-72 hours) between training days
                // Consecutive days cannot be selected
                bool conflict = false;
                List<String> daysOfWeek = [
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                  'Saturday',
                  'Sunday'
                ];
                for (int i = 0; i < 7; i++) {
                  if (_daysOfWeek[daysOfWeek[i]]) {
                    if (i == 0) {
                      if (_daysOfWeek[daysOfWeek[6]]) {
                        conflict = true;
                      }
                    } else {
                      if (_daysOfWeek[daysOfWeek[i - 1]]) {
                        conflict = true;
                      }
                    }
                    if (i == 6) {
                      if (_daysOfWeek[daysOfWeek[0]]) {
                        conflict = true;
                      }
                    } else {
                      if (_daysOfWeek[daysOfWeek[i + 1]]) {
                        conflict = true;
                      }
                    }
                  }
                }
                if (conflict) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Cool Down Period between training sessions has to be at least 48 hours'),
                  ));
                  return;
                }

                // show loading dialog
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    });

                if (await NLPFactory.getNLP(
                        widget._program, _inc, _workoutOptions)
                    .checkConflict(_daysOfWeek, _startDate)) {
                  // check if is conflicting with existing workout plan
                  // if it is conflict, prompt to user to determine if they want to continue
                  bool confirmed = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Warning'),
                      content: Text(
                          'Training plan already exist, do you want to override your previous training plan?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('Continue',
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                  );
                  if (!confirmed) {
                    Navigator.pop(context); // pop the dialog
                    return;
                  }
                  await NLPFactory.getNLP(
                          widget._program, _inc, _workoutOptions)
                      .cleanConflict(
                          _daysOfWeek, _startDate); // clean the workout plan
                }

                // save the workout plan
                await NLPFactory.getNLP(widget._program, _inc, _workoutOptions)
                    .saveToDatabase(
                        _daysOfWeek, _startDate); // save the workout plan
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Workout plan added to calendar'),
                ));
                Navigator.pop(context); // pop the dialog
                Navigator.pop(context); // pop the view
                widget._viewModel.loadTrainingData(); // reload the calendar
              },
            ),
          ],
        )));
  }
}
