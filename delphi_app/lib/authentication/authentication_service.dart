import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/account_creation_response.dart';
import '../model/login_response.dart';
import '../model/user_profile.dart';
import '../profile/user_profile_service.dart';

class AuthenticationService {
  static Future<LoginResponse?> login(String email, String password) async {
    final url = Uri.parse('https://user.fleure.workers.dev/api/Login');
    final response = await http.post(
      url,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return LoginResponse.fromJson(responseData);
    } else {
      return null;
    }
  }

  static Future<AccountCreationResponse?> signup(
      String username, String email, String password) async {
    final url = Uri.parse('https://user.fleure.workers.dev/api/CreateAccount');
    final response = await http.post(
      url,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 400 ||
        response.statusCode == 500) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return AccountCreationResponse.fromJson(responseData);
    } else {
      return null;
    }
  }

  // Function to fetch user profile after login and update Singleton
  static Future<void> fetchUserProfile(int userId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://user.fleure.workers.dev/api/GetProfileDetails/$userId'),
        headers: {'accept': '*/*'},
      );

      if (response.statusCode == 200) {
        // Parse the response body
        final data = json.decode(response.body);
        if (data['success']) {
          final user = data['user'];

          // Update the UserProfile singleton with fetched data
          UserProfile().login(
            userId: userId,
            username: user['username'],
            isAdmin: user['admin'] == 1,
            balance: user['balance'],
            bankruptcyCount: user['bankruptcy_count'],
            totalBets: user['total_bets'],
            currentBets: user['curr_bets'],
            totalCreditsPlaying: user['total_credits_playing'],
            totalCreditsBet: user['total_credits_bet'],
            totalCreditsWon: user['total_credits_won'],
            premiumAccount: user['premium_account'] == 1,
            profitMultiplier: user['profit_multiplier'],
          );

          UserProfileService().saveUserProfile();
        } else {
          // Handle failure
          print('Failed to fetch user profile. 1');
        }
      } else {
        // Handle network failure or non-200 status code
        print('Failed to load user profile. 2');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  // Function to fetch user profile after login and update Singleton
  static Future<bool> deleteAccount(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('https://user.fleure.workers.dev/api/DeleteAccount/$userId'),
        headers: {'accept': '*/*'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return true;
        }
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
    return false;
  }
}
