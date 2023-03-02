import 'package:flutter/material.dart';
import 'package:gymapp/models/exercise.dart';
import 'package:gymapp/screens/exercise_library.dart';
import 'package:gymapp/services/plan.dart';

// The ExerciseCard widget is used to display the exercise information in a card.
class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final RouteObserver<PageRoute> routeObserver;

  ExerciseCard({Key key, @required this.exercise, @required this.routeObserver})
      : super(key: key);

// The build method is used to create the widget.
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(exercise.image),
          SizedBox(height: 20),
          Text(exercise.name, style: Theme.of(context).textTheme.headline4),
          SizedBox(height: 20),
          Text(exercise.description,
              style: Theme.of(context).textTheme.bodyText2),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to the exercise detail screen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ExerciseDetailScreen(
                      exercise: exercise, routeObserver: routeObserver),
                ),
              );
            },
            child: Text('Start Next Training'),
          ),
        ],
      ),
    );
  }
}
