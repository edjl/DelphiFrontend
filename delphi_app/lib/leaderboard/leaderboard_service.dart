import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/leaderboard_profile.dart';

class LeaderboardService {
  static Future<List<LeaderboardProfile>> getLeaderboard(
      [String orderBy = "balance", String orderDirection = "desc"]) async {
    // Construct query parameters
    final queryParameters = {
      'order_by': orderBy,
      'order_direction': orderDirection,
    };

    const baseUrl = "https://leaderboard.fleure.workers.dev/api/leaderboard";

    final url = Uri.parse(baseUrl).replace(queryParameters: queryParameters);

    List<dynamic> leaderboard;
    try {
      final response = await http.get(url);

      if (response.statusCode == 400) {
        return Future.value([]);
      } else if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          leaderboard = responseBody['outcomes'];
        } else {
          throw Exception('Failed to fetch events: ${responseBody['message']}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }

    return leaderboard
        .map((json) => LeaderboardProfile.fromJson(json))
        .toList();
  }
}
