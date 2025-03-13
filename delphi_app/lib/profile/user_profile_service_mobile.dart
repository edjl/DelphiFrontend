import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_profile.dart';

Future<void> loadUserProfileFromLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  int userId = prefs.getInt('userId') ?? -1;
  UserProfile().userId.value = userId;
}

Future<void> saveUserProfileToLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('userId', UserProfile().userId.value);
}
