import 'package:web/web.dart' as web;

void setCookie(String name, int value, {int days = 7}) {
  final expires =
      DateTime.now().add(Duration(days: days)).toUtc().toIso8601String();
  String cookie = '$name=$value; expires=$expires; path=/;';

  // Ensure Secure and SameSite policies
  if (web.window.location.protocol == 'https:') {
    cookie += ' Secure;';
  }
  cookie += ' SameSite=Strict;';

  web.window.document.cookie = cookie;
}

int? getCookie(String name) {
  final cookies = web.window.document.cookie.split('; ');
  for (var cookie in cookies) {
    final parts = cookie.split('=');
    if (parts.length == 2 && parts[0] == name) {
      return int.parse(parts[1]);
    }
  }
  return null;
}
