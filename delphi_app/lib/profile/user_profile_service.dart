import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding

class UserProfileService {
  Future<void> loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt('userId') ?? -1;
    if (userId != -1) {
      UserProfile().userId.value = userId;
      UserProfile().username = prefs.getString('username') ?? "DefaultUser";
      UserProfile().balance.value = prefs.getInt('balance') ?? 0;
      UserProfile().isAdmin = prefs.getBool('isAdmin') ?? false;
      UserProfile().bankruptcyCount = prefs.getInt('bankruptcyCount') ?? 0;
      UserProfile().totalBets = prefs.getInt('totalBets') ?? 0;
      UserProfile().currentBets = prefs.getInt('currentBets') ?? 0;
      UserProfile().totalCreditsPlaying =
          prefs.getInt('totalCreditsPlaying') ?? 0;
      UserProfile().totalCreditsBet = prefs.getInt('totalCreditsBet') ?? 0;
      UserProfile().totalCreditsWon = prefs.getInt('totalCreditsWon') ?? 0;
      UserProfile().premiumAccount = prefs.getBool('premiumAccount') ?? false;
      UserProfile().profitMultiplier = prefs.getInt('profitMultiplier') ?? 100;
    }

    refresh();
    saveUserProfile();
  }

  Future<void> saveUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('userId', UserProfile().userId.value);
    prefs.setString('username', UserProfile().username);
    prefs.setBool('isAdmin', UserProfile().isAdmin);
    prefs.setInt('balance', UserProfile().balance.value);
    prefs.setInt('bankruptcyCount', UserProfile().bankruptcyCount);
    prefs.setInt('totalBets', UserProfile().totalBets);
    prefs.setInt('currentBets', UserProfile().currentBets);
    prefs.setInt('totalCreditsPlaying', UserProfile().totalCreditsPlaying);
    prefs.setInt('totalCreditsBet', UserProfile().totalCreditsBet);
    prefs.setInt('totalCreditsWon', UserProfile().totalCreditsWon);
    prefs.setBool('premiumAccount', UserProfile().premiumAccount);
    prefs.setInt('profitMultiplier', UserProfile().profitMultiplier);
  }

  void refresh() async {
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
          UserProfile().balance = user['balance'];
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
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }
}
