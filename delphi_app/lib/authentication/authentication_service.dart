import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/account_creation_response.dart';
import '../model/login_response.dart';

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
}

// TODO: create a new user with signup notification
