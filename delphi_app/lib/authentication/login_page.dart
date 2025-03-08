import 'package:delphi_app/authentication/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // For JSON decoding
import 'authentication_service.dart'; // Assuming you have the AuthenticationService class
import '../model/login_response.dart'; // Assuming you have the LoginResponse model
import '../model/user_profile.dart'; // Import UserProfile singleton
import '../authentication/signup_page.dart';
import '../shared_views/app_bar.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  _signup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String email = emailController.text;
    final String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _isLoading = false;
      if (email.isEmpty) {
        _errorMessage = 'Enter an email';
      } else if (password.isEmpty) {
        _errorMessage = 'Enter a password';
      }
      return;
    }

    LoginResponse? response =
        await AuthenticationService.login(email, password);

    setState(() {
      _isLoading = false;
    });

    if (response != null) {
      // Successfully logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Fetch the user profile data after successful login
      AuthenticationService.fetchUserProfile(response.userId);
    } else {
      // Login failed
      setState(() {
        _errorMessage = 'Invalid email or password.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Login',
        height: 68,
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: emailController,
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: passwordController,
                maxLength: 50,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 5),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 13),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Colors.black, width: 1.5),
                        ),
                      ),
                      child: const Text('Login'),
                    ),
              const SizedBox(height: 10),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 35),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'New Member?',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextButton(
                      onPressed: _signup,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                        overlayColor: Colors.lightBlue,
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
