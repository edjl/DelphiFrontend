import 'package:delphi_app/authentication/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // For JSON decoding
import 'authentication_service.dart'; // Assuming you have the AuthenticationService class
import '../model/login_response.dart'; // Assuming you have the SignUpResponse model
import '../model/user_profile.dart'; // Import UserProfile singleton
import '../profile/user_profile_service.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  void _signup() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String username = usernameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _isLoading = false;
      if (username.isEmpty) {
        _errorMessage = 'Enter a username';
      } else if (email.isEmpty) {
        _errorMessage = 'Enter an email';
      } else if (password.isEmpty) {
        _errorMessage = 'Enter a password';
      }
      return;
    }

    // Basic email validation with regex
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      _isLoading = false;
      _errorMessage = 'Enter a valid email';
      return;
    }

    var response =
        await AuthenticationService.signup(username, email, password);

    setState(() {
      _isLoading = false;
    });

    if (response != null) {
      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signup successful!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        LoginResponse? loginResponse =
            await AuthenticationService.login(email, password);

        if (loginResponse != null) {
          // Fetch user profile
          await AuthenticationService.fetchUserProfile(loginResponse.userId);
          Navigator.pop(context);
        }
      } else {
        setState(() {
          _errorMessage = response.result;
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Connection error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Sign Up',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans',
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.visible,
            softWrap: true,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: 16.0), // Padding inside the container
          color: Colors.white, // Set background color to white
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: usernameController,
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 5),
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
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _signup,
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
                          side:
                              const BorderSide(color: Colors.black, width: 1.5),
                        ),
                      ),
                      child: const Text('Sign Up'),
                    ),
              const SizedBox(height: 10),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 50),
            ],
          ),
        ));
  }
}
