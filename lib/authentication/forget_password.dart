import 'package:flutter/material.dart';
import 'package:gymapp/services/auth_service.dart';

// The ForgetPasswordScreen class is used to display the forget password screen.
class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() =>
      _ForgetPasswordScreenState(); // Create the state.
}

// The _ForgetPasswordScreenState class is used to manage the state of the forget password screen.
class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>(); // Create a form key.
  static final _service = AuthService.forgotPassword; // Create a service.
  String _email; // Create an email variable.

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
      // Try to communicate with the service.
      await _service(_email); // Communicate with the service.
      // show success message
      ScaffoldMessenger.of(context).showSnackBar(
          // SnackBar(content: Text('Reset link has been sent to your email')));
          SnackBar(content: Text('Your password has been reset to 123456')));
    } catch (e) {
      // show error message
    }
  }

// The build method builds the widget.
  @override
  Widget build(BuildContext context) {
    // Return a Scaffold widget.
    return Scaffold(
      body: SingleChildScrollView(
        // Use a SingleChildScrollView widget.
        child: Container(
          // Use a Container widget.
          height: MediaQuery.of(context).size.height, // Set the height.
          child: Column(
            // Use a Column widget.
            mainAxisAlignment: MainAxisAlignment.center, // Center the children.
            children: <Widget>[
              // Add the children.
              Text("Forget Password"), // Add a text widget.
              Form(
                key: _formKey, // Set the form key.
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10), // Set the padding.
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Email"),
                        validator: (input) => !input.contains('@')
                            ? 'Please enter a valid email'
                            : null,
                        onSaved: (input) => _email = input, // Set the email.
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
                        child: Text("Send reset link"),
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
                        child: Text("Back to login"),
                      ), // Add a text button widget.
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
