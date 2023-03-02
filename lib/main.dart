import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'authentication/login.dart';
import 'authentication/signup.dart';
import 'authentication/forget_password.dart';

import 'screens/home.dart';
import 'screens/log.dart';
import 'screens/progress.dart';
import 'screens/exercise_library.dart';
import 'screens/training_plan.dart';
import 'screens/stop_watch.dart';
import 'screens/help.dart';

import 'services/auth_service.dart';
import 'services/training.dart';
import 'services/plan.dart';

import 'utils/reminder.dart';

// The main function is the starting point for all our Flutter apps.
void main() {
  runApp(MyApp()); // Run the app.

  setup(); // Initialize the app.
}

// The setup function is used to initialize the app.
Future<void> setup() async {
  await AuthService.setup(); // Initialize the authentication service.
  await TrainingService.setup(); // Initialize the training service.
  await PlanService.setup(); // Initialize the plan service.
  var status = await Permission
      .notification.status; // Get the notification permission status.
  if (status.isUndetermined) {
    // If the permission status is undetermined, request the permission.
    await Permission.notification.request();
  }
  initNotifications(); // Initialize the notifications.
}

// The MyApp class is the root of our app.
class MyApp extends StatelessWidget {
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  // The build method builds the widget.
  @override
  Widget build(BuildContext context) {
    // Return a MaterialApp widget.
    return MaterialApp(
      title: 'Workout Tracker',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/forget': (context) => ForgetPasswordScreen(),
        '/home': (context) => HomeScreen(routeObserver),
        '/log': (context) => LogScreen(),
        '/progress': (context) => ProgressScreen(routeObserver),
        '/exercise-library': (context) => ExerciseLibraryScreen(routeObserver),
        '/training-plan': (context) => TrainingPlanScreen(),
        '/watch': (context) => StopwatchScreen(),
        '/help': (context) => HelpScreen(),
      },
      navigatorObservers: [routeObserver],
    );
  }
}
