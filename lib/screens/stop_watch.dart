import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymapp/utils/reminder.dart';

// The StopwatchScreen class is used to display the stopwatch screen.
class StopwatchScreen extends StatefulWidget {
  @override
  _StopwatchScreenState createState() =>
      _StopwatchScreenState(); // Return a _StopwatchScreenState widget.
}

// The _StopwatchScreenState class is used to display the stopwatch screen.
class _StopwatchScreenState extends State<StopwatchScreen> {
  int _hours = 0; // default value for the hours
  int _minutes = 3; // default value for the minutes
  int _seconds = 0; // default value for the seconds
  int _hourCopy = 0; // default value for the hours
  int _minuteCopy = 0; // default value for the minutes
  int _secondCopy = 0; // default value for the seconds
  Timer _timer; // Timer object

// The initState method is used to initialize the state of the widget.
  @override
  void initState() {
    super.initState(); // Call the super class method.
  }

  // The dispose method is used to dispose the state of the widget.
  @override
  void dispose() {
    super.dispose(); // Call the super class method.
    if (_timer != null) _timer.cancel(); // Cancel the timer.
  }

// The build method builds the widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Return a Scaffold widget.
      appBar: AppBar(
        title: Text('Stopwatch'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0), // Set the padding.
            child: Text('Input the time for the countdown'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  _hours = int.parse(value);
                }); // Set the state.
              },
              initialValue: _hours.toString(),
              keyboardType: TextInputType.number,
              // only allow the user to input digits
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'Hours',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  _minutes = int.parse(value);
                }); // Set the state.
              },
              initialValue: _minutes.toString(),
              keyboardType: TextInputType.number,
              // only allow the user to input digits
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'Minutes',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  _seconds = int.parse(value);
                }); // Set the state.
              },
              initialValue: _seconds.toString(),
              keyboardType: TextInputType.number,
              // only allow the user to input digits
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'Seconds',
              ),
            ),
          ),
          SizedBox(height: 20.0),
          // A Text widget to display the remain time.
          Text('$_hourCopy : $_minuteCopy : $_secondCopy',
              style: TextStyle(fontSize: 30.0)),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // Count down the time for every second
              // and display the remain time.
              setState(() {
                _hourCopy = _hours;
                _minuteCopy = _minutes;
                _secondCopy = _seconds;
                if (_timer != null) _timer.cancel();
                _timer = Timer.periodic(Duration(seconds: 1), (timer) {
                  setState(() {
                    if (_secondCopy > 0) {
                      _secondCopy--;
                    } else if (_minuteCopy > 0) {
                      _minuteCopy--;
                      _secondCopy = 59;
                    } else if (_hourCopy > 0) {
                      _hourCopy--;
                      _minuteCopy = 59;
                      _secondCopy = 59;
                    } else {
                      _timer.cancel();
                    }
                  });
                });
              });

              // scheduleReminder(
              //     DateTime.now().add(Duration(
              //         hours: _hours, minutes: _minutes, seconds: _seconds)),
              //     'Time to workout!'); // Call the scheduleReminder method.
            },
            child: Text('Start Timer'),
          )
        ],
      ),
    );
  }
}
