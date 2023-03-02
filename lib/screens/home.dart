import 'package:flutter/material.dart';
import 'package:gymapp/services/inter.dart';
import 'package:gymapp/services/training.dart';

// The HomeScreen class is used to display the home screen.
class HomeScreen extends StatefulWidget {
  final RouteObserver<PageRoute> routeObserver;
  HomeScreen(this.routeObserver);

  @override
  _HomeScreenState createState() =>
      _HomeScreenState(); // Return a _HomeScreenState widget.
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  int finished = 0; // default value for the finished workouts
  int planned = 0; // default value for the planned workouts
  int finishDays = 0; // default value for the finish days
  int planDays = 0; // default value for the plan days

  // The initState method is used to initialize the state of the widget.
  @override
  void initState() {
    super.initState(); // Call the super class method.
    InterService.countFutureWorkouts().then((value) {
      setState(() {
        planned = value;
      });
      InterService.countFutureDays().then((value) {
        setState(() {
          planDays = value;
        });
        InterService.countFinishedDays().then((value) {
          setState(() {
            finishDays = value;
          });
        });
      });
    });
    TrainingService.countWorkouts().then((value) {
      setState(() {
        finished = value;
      });
    });
  }

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
    showHomeScreen();
  }

  // The callback of home screen to shown
  void showHomeScreen() {
    InterService.countFutureWorkouts().then((value) {
      setState(() {
        planned = value;
      });
      InterService.countFutureDays().then((value) {
        setState(() {
          planDays = value;
        });
        InterService.countFinishedDays().then((value) {
          setState(() {
            finishDays = value;
          });
        });
      });
    });
    TrainingService.countWorkouts().then((value) {
      setState(() {
        finished = value;
      });
    });
  }

  // The build method builds the widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Return a Scaffold widget.
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        // Return a Column widget.
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text('Welcome to your virtual Gym-trainer!',
                  style: Theme.of(context)
                      .textTheme
                      .headline6), // Return a Text widget as header
            ),
          ),
          Expanded(
            child: Center(
                child: Column(
              children: [
                Text(
                    'According to your Novice Linear Programming Training Plan'),
                Text(
                    '$finishDays sessions ($finished workouts) has been completed'),
                Text(
                    '$planDays upcoming sessions ($planned workouts) in the plan.'), // Return a Text widget.
              ],
            )),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the row.
              children: <Widget>[
                InkWell(
                  // Return an InkWell widget.(button)
                  onTap: () {
                    // When the button is tapped, navigate to the log screen.
                    Navigator.pushNamed(context, '/log');
                  },
                  child: Container(
                    width: 150.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.red, // Set the color of the button.
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Center(
                      child: Text(
                        'Log',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 50),
                InkWell(
                  // Return an InkWell widget.(button)
                  onTap: () {
                    // When the button is tapped, navigate to the progress screen.
                    Navigator.pushNamed(context, '/progress');
                  },
                  child: Container(
                    width: 150.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.green, // Set the color of the button.
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Center(
                      child: Text(
                        'Progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the row.
              children: <Widget>[
                InkWell(
                  // Return an InkWell widget.(button)
                  onTap: () {
                    // When the button is tapped, navigate to the exercise library screen.
                    Navigator.pushNamed(context, '/exercise-library');
                  },
                  child: Container(
                    width: 150.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.blue, // Set the color of the button.
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Center(
                      child: Text(
                        'Exercise Library',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 50),
                InkWell(
                  // Return an InkWell widget.(button)
                  onTap: () {
                    // When the button is tapped, navigate to the training plan screen.
                    Navigator.pushNamed(context, '/training-plan');
                  },
                  child: Container(
                    width: 150.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.orange, // Set the color of the button.
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Center(
                      child: Text(
                        'Training Plan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the row.
              children: <Widget>[
                InkWell(
                  // Return an InkWell widget.(button)
                  onTap: () {
                    // When the button is tapped, navigate to the stopwatch screen.
                    Navigator.pushNamed(context, '/watch');
                  },
                  child: Container(
                    width: 150.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.purple, // Set the color of the button.
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Center(
                      child: Text(
                        'Stopwatch',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 50),
                InkWell(
                  // Return an InkWell widget.(button)
                  onTap: () {
                    // When the button is tapped, navigate to the training plan screen.
                    Navigator.pushNamed(context, '/help');
                  },
                  child: Container(
                    width: 150.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.brown, // Set the color of the button.
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Center(
                      child: Text(
                        'Help',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
