import 'package:delphi_app/authentication/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // For JSON decoding
import 'authentication_service.dart'; // Assuming you have the AuthenticationService class
import '../model/login_response.dart'; // Assuming you have the SignUpResponse model
import '../model/user_profile.dart'; // Import UserProfile singleton
import '../profile/user_profile_service.dart';

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

  // Function to fetch user profile after login and update Singleton
  // Future<void> _fetchUserProfile(int userId) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse(
  //           'https://user.fleure.workers.dev/api/GetProfileDetails/$userId'),
  //       headers: {'accept': '*/*'},
  //     );

  //     if (response.statusCode == 200) {
  //       // Parse the response body
  //       final data = json.decode(response.body);
  //       if (data['success']) {
  //         final user = data['user'];

  //         // Update the UserProfile singleton with fetched data
  //         UserProfile().login(
  //           userId: userId,
  //           username: user['username'],
  //           isAdmin: user['admin'] == 1,
  //           balance: user['balance'],
  //           bankruptcyCount: user['bankruptcy_count'],
  //           totalBets: user['total_bets'],
  //           currentBets: user['curr_bets'],
  //           totalCreditsPlaying: user['total_credits_playing'],
  //           totalCreditsBet: user['total_credits_bet'],
  //           totalCreditsWon: user['total_credits_won'],
  //           premiumAccount: user['premium_account'] == 1,
  //           profitMultiplier: user['profit_multiplier'],
  //         );

  //         print('Username: ${user['username']}');
  //         print('Balance: ${user['balance']}');

  //         UserProfileService().saveUserProfile();
  //       } else {
  //         // Handle failure
  //         print('Failed to fetch user profile.');
  //       }
  //     } else {
  //       // Handle network failure or non-200 status code
  //       print('Failed to load user profile.');
  //     }
  //   } catch (e) {
  //     print('Error fetching user profile: $e');
  //   }
  // }

  void _signup() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String username = usernameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    var response =
        await AuthenticationService.signup(username, email, password);

    setState(() {
      _isLoading = false;
    });

    if (response != null) {
      if (response.success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Signup successful!')));
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = response.result;
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Connection error.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signup,
                    child: Text('Sign Up'),
                  ),
            SizedBox(height: 10),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
