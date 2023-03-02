import 'package:flutter/material.dart';
import 'package:gymapp/services/auth_service.dart';
import 'package:gymapp/services/plan.dart';
import 'package:gymapp/services/training.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: Center(
        child: Column(children: [
          SizedBox(height: 20),

          Text('Tips', style: Theme.of(context).textTheme.headline6),
          SizedBox(height: 10),
          Column(
            // create a padding to the column
            children: [
              // A list of tips to help the user to use this app.
              Text('1. Find a suitable plan for you in "Training Plan".'),
              Text(
                  '2. Start your exercise in the "Exercise Library" with tutorial.'),
              Text('3. Tap the "Stopwatch" button to use the stopwatch.'),
              Text('4. Log your exercise in the "Log" page.'),
              Text(
                  '5. Tap the "Progress" button to view all your training progress.'),
            ],
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),

          SizedBox(height: 20),
          // A reset button to reset the app.
          ElevatedButton(
            // the button set to red to show that it is dangerous.
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              // When the button is tapped, reset the app.
              // show a dialog to confirm the reset
              bool confirmed = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Reset all data?'),
                  content: Text(
                      'This will delete all your data, which cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Reset', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirmed) {
                // await AuthService.reset();
                await TrainingService.reset();
                await PlanService.reset();
                // clear the stack
                Navigator.popUntil(context, (route) => route.isFirst);
                // restart the app
                // Navigator.pushReplacementNamed(context, '/');
              }
            },
            child: Text('Reset all data'),
          ),
        ]),
      ),
    );
  }
}
