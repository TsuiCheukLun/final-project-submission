import 'package:flutter/material.dart';
import 'package:gymapp/models/user.dart';
import 'package:gymapp/services/auth_service.dart';

// The SignupScreen class is used to display the signup screen.
class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState(); // Create the state.
}

// The _SignupScreenState class is used to manage the state of the signup screen.
class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>(); // Create a form key.
  static final _service = AuthService.signup; // Create a service.
  String _name,
      _email,
      _password; // Create name, email, and password variables.

// The _trySubmit function is used to try to submit the form.
  _trySubmit() async {
    if (_formKey.currentState.validate()) {
      // If the form is valid.
      _formKey.currentState.save(); // Save the form.
      await _communicateService(); // Communicate with the service.
    }
  }

// The _communicateService function is used to communicate with the service.
  _communicateService() async {
    try {
      User user = await _service(
          _name, _email, _password); // Communicate with the service.
      _servicePostAction(user); // Perform post action.
    } catch (e) {
      // show error message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Duplicated email')));
    }
  }

// The _servicePostAction function is used to perform post action.
  _servicePostAction(User user) {
    if (user != null) {
      // If the user is not null.
      Navigator.pushReplacementNamed(
          context, '/home'); // Navigate to the home screen.
    } else {
      // If the user is null.
      // show error message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Register failed')));
    }
  }

// The build method builds the widget.
  @override
  Widget build(BuildContext context) {
    // Return a Scaffold widget.
    return Scaffold(
      body: SingleChildScrollView(
        // Return a SingleChildScrollView widget.
        child: Container(
          height: MediaQuery.of(context).size.height, // Get the height.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the children.
            children: <Widget>[
              Text("Signup"),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Name"),
                        validator: (input) => input.length <
                                3 // If the input is less than 3 characters.
                            ? 'Must be at least 3 characters'
                            : null,
                        onSaved: (input) => _name = input,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Email"),
                        validator: (input) => !input.contains(
                                '@') // If the input does not contain an @.
                            ? 'Please enter a valid email'
                            : null,
                        onSaved: (input) => _email = input,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Password"),
                        validator: (input) => input.length <
                                6 // If the input is less than 6 characters.
                            ? 'Must be at least 6 characters'
                            : null,
                        onSaved: (input) => _password = input,
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: _trySubmit, // Try to submit the form.
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                        child: Text("Signup"),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          // navigate to the login page
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                        child: Text("Already have an account? Login"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
