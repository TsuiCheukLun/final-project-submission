import 'package:flutter/material.dart';
import 'package:gymapp/models/exercise.dart';
import 'package:gymapp/models/workout.dart';
import 'package:gymapp/services/inter.dart';
import 'package:gymapp/widgets/exercise_card.dart';
import 'package:gymapp/services/exercise.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// The ExerciseLibraryScreen class is used to display the exercise library screen.
class ExerciseLibraryScreen extends StatelessWidget {
  final List<Exercise> exercises =
      ExerciseService.getAllExercises(); // Get all exercises.
  final RouteObserver<PageRoute> routeObserver;
  ExerciseLibraryScreen(this.routeObserver);

// The build method builds the widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Return a Scaffold widget.
        appBar: AppBar(
          title: Text('Exercise Library'),
        ),
        body: Container(
          // Return a Container widget.
          child: ListView.builder(
            // Return a ListView widget.
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              return ExerciseCard(
                  exercise: exercises[index],
                  routeObserver:
                      routeObserver); // Return an ExerciseCard widget.
            },
          ),
        ));
  }
}

// The ExerciseDetailScreen class is used to display the exercise detail screen.
class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise; // Create an exercise variable.
  final RouteObserver<PageRoute> routeObserver;

  ExerciseDetailScreen(
      {Key key, @required this.exercise, @required this.routeObserver})
      : super(key: key); // Create the constructor.

  @override
  _ExerciseDetailScreenState createState() =>
      _ExerciseDetailScreenState(); // Create the state.
}

// The _ExerciseDetailScreenState class is used to manage the state of the exercise detail screen.
class _ExerciseDetailScreenState extends State<ExerciseDetailScreen>
    with RouteAware {
  YoutubePlayerController _controller; // Create a controller.
  Workout workout;

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
    InterService.findNextUntrainedWorkout(widget.exercise.name).then((value) {
      setState(() {
        workout = value;
      });
    });
  }

// The initState method is used to initialize the state.
  @override
  void initState() {
    super.initState(); // Call the super method.
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
          widget.exercise.video), // Get the video ID.
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    ); // Initialize the controller.
    InterService.findNextUntrainedWorkout(widget.exercise.name).then((value) {
      setState(() {
        workout = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Return a Scaffold widget.
        appBar: AppBar(
          title: Text(widget.exercise.name),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.asset(widget.exercise.image),
              SizedBox(height: 20),
              Text(widget.exercise.name,
                  style: Theme.of(context).textTheme.headline4),
              SizedBox(height: 20),
              Text(widget.exercise.description,
                  style: Theme.of(context).textTheme.bodyText2),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Align the column to the start.
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align the column to the start.
                children: [
                  Text('Steps:', style: Theme.of(context).textTheme.headline6),
                  ...(widget.exercise.steps
                      .asMap()
                      .entries
                      .map((step) => Text('${step.key + 1}. ${step.value}'))
                      .toList()), // Map the steps to a list of Text widgets.
                ],
              ),
              SizedBox(height: 20),
              // add a button to open the stopwatch
              ElevatedButton(
                child: Text('Start Stopwatch'),
                onPressed: () {
                  // open the stopwatch
                  Navigator.pushNamed(context, '/watch');
                },
              ),
              if (workout != null) ...[
                SizedBox(height: 20),
                Text('Next Training:',
                    style: Theme.of(context).textTheme.headline6),
                Text(workout.mode_type),
                Text('Sets: ${workout.sets}'),
                Text('Reps: ${workout.reps}'),
                Text('Weight: ${workout.weight}'),
                // a button to add the exercise to log
                ElevatedButton(
                  child: Text('Add to Log'),
                  onPressed: () {
                    _controller.pause();
                    // add the exercise to the log
                    Navigator.pushNamed(context, '/log',
                        arguments: workout.name);
                  },
                ),
              ],
              if (workout == null) ...[
                SizedBox(height: 20),
                Text(
                    'Great Job! You have finished all ${widget.exercise.name} training of today',
                    style: Theme.of(context).textTheme.headline6),
              ],
              SizedBox(height: 40),
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onReady: () {
                  _controller.play();
                },
              ), // Return a YoutubePlayer widget.
            ],
          ),
        ));
  }
}
