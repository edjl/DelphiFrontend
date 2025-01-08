import 'package:shared_preferences/shared_preferences.dart';
import 'model/user_profile.dart';

class UserProfileService {
  Future<void> loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt('userId') ?? -1;
    if (userId != -1) {
      UserProfile().userId.value = userId;
      UserProfile().username = prefs.getString('username') ?? "DefaultUser";
      UserProfile().balance = prefs.getInt('balance') ?? 0;
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
  }

  Future<void> saveUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('userId', UserProfile().userId.value);
    prefs.setString('username', UserProfile().username);
    prefs.setBool('isAdmin', UserProfile().isAdmin);
    prefs.setInt('balance', UserProfile().balance);
    prefs.setInt('bankruptcyCount', UserProfile().bankruptcyCount);
    prefs.setInt('totalBets', UserProfile().totalBets);
    prefs.setInt('currentBets', UserProfile().currentBets);
    prefs.setInt('totalCreditsPlaying', UserProfile().totalCreditsPlaying);
    prefs.setInt('totalCreditsBet', UserProfile().totalCreditsBet);
    prefs.setInt('totalCreditsWon', UserProfile().totalCreditsWon);
    prefs.setBool('premiumAccount', UserProfile().premiumAccount);
    prefs.setInt('profitMultiplier', UserProfile().profitMultiplier);
  }
}
