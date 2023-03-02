import 'package:flutter/material.dart';
import 'package:gymapp/models/user.dart';
import 'package:gymapp/services/auth_service.dart';

final bool DEVELOPMENT = false; // set to true to skip login

// The LoginScreen class is used to display the login screen.
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState(); // Create the state.
}

// The _LoginScreenState class is used to manage the state of the login screen.
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Create a form key.
  static final _service = AuthService.login; // Create a service.
  String _email =
          DEVELOPMENT ? 'test@example.com' : '', // Create an email variable.
      _password = DEVELOPMENT ? '123456' : ''; // Create a password variable.

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
      User user =
          await _service(_email, _password); // Communicate with the service.
      _servicePostAction(user); // Perform post action.
    } catch (e) {
      // show error message
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
          .showSnackBar(SnackBar(content: Text('Invalid email or password')));
    }
  }

// The build method builds the widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Return a Scaffold widget.
      body: SingleChildScrollView(
        // Return a SingleChildScrollView widget.
        child: Container(
          height: MediaQuery.of(context).size.height, // Set the height.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the children.
            children: <Widget>[
              Text("Login"),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Email"),
                        validator: (input) =>
                            !input.contains('@') // validate email
                                ? 'Please enter a valid email'
                                : null,
                        initialValue: _email,
                        onSaved: (input) => _email = input,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Password"),
                        validator: (input) =>
                            input.length < 6 // validate password
                                ? 'Must be at least 6 characters'
                                : null,
                        onSaved: (input) => _password = input,
                        initialValue: _password,
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: _trySubmit,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                        child: Text("Login"),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          // navigate to the signup page
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                        child: Text("Don't have an account? Sign up"),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          // navigate to the forget password page
                          Navigator.pushReplacementNamed(context, '/forget');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                        child: Text("Forgot password?"),
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
