import '../model/user_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding

import 'package:flutter/foundation.dart'; // For checking if web or mobile
import 'user_profile_service_mobile.dart';
import 'user_profile_service_web.dart';

class UserProfileService {
  Future<void> loadUserProfile() async {
    if (kIsWeb) {
      UserProfile().userId.value = getCookie("user_id") ?? -1;
    } else {
      // App-specific: Load from local storage
      await loadUserProfileFromLocalStorage();
    }
    refresh();
  }

  Future<void> saveUserProfile() async {
    if (kIsWeb) {
      setCookie("user_id", UserProfile().userId.value);
    } else {
      // App-specific: Save to local storage
      saveUserProfileToLocalStorage();
    }
  }

  void refresh() async {
    if (UserProfile().userId.value == -1) {
      return;
    }
    try {
      final response = await http.get(
        Uri.parse(
            'https://user.fleure.workers.dev/api/GetProfileDetails/${UserProfile().userId.value}'),
        headers: {'accept': '*/*'},
      );

      if (response.statusCode == 200) {
        // Parse the response body
        final data = json.decode(response.body);
        if (data['success']) {
          final user = data['user'];

          UserProfile().username = user['username'];
          UserProfile().isAdmin = user['admin'] == 1;
          UserProfile().balance.value = user['balance'];
          UserProfile().bankruptcyCount = user['bankruptcy_count'];
          UserProfile().totalBets = user['total_bets'];
          UserProfile().currentBets = user['curr_bets'];
          UserProfile().totalCreditsPlaying = user['total_credits_playing'];
          UserProfile().totalCreditsBet = user['total_credits_bet'];
          UserProfile().totalCreditsWon = user['total_credits_won'];
          UserProfile().premiumAccount = user['premium_account'] == 1;
          UserProfile().profitMultiplier = user['profit_multiplier'];

          UserProfileService().saveUserProfile();
        } else {
          // Handle failure
          print('Failed to fetch user profile.');
        }
      } else {
        // Handle network failure or non-200 status code
        print('Failed to load user profile.');
        final data = json.decode(response.body);
        if (data['error'] == "ID not found") {
          UserProfile().userId.value = -1;
          saveUserProfile();
        }
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }
}
