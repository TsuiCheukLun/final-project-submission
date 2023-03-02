import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

// The ProgressChart widget is used to display the user's training data in the form of a graph.
class ProgressChart extends StatelessWidget {
  final List<charts.Series> seriesList; // The list of series
  final bool animate; // The animation

  ProgressChart(this.seriesList, {this.animate}); // The constructor

// The build method is used to create the chart.
  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(
      seriesList,
      animate: animate,
    );
  }
}
