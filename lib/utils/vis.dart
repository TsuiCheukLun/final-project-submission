import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gymapp/models/exercise.dart';

// The implementation of visualization
// This function creates a list of charts.Series that will be used to display the user's training data in the form of a graph.
// The type of data that is displayed (weight or volume) is determined by the value of _selectedDataPoint.
// If _selectedDataPoint is 'weight', the graph will show the user's starting weight for each exercise.
// If _selectedDataPoint is 'volume', the graph will show the total volume (sets * reps) for each exercise.
List<charts.Series<Exercise, num>> createExerciseData(
    String _selectedDataPoint, List<Exercise> _exerciseData) {
  if (_selectedDataPoint == 'weight') {
    return [
      charts.Series<Exercise, num>(
        id: 'Exercise',
        data: _exerciseData,
        domainFn: (Exercise exercise, i) => i,
        measureFn: (Exercise exercise, _) => exercise.weight,
      )
    ];
  } else if (_selectedDataPoint == 'volume') {
    return [
      charts.Series<Exercise, num>(
        id: 'Exercise',
        data: _exerciseData,
        domainFn: (Exercise exercise, i) => i,
        measureFn: (Exercise exercise, _) => exercise.sets * exercise.reps,
      )
    ];
  }
}
