import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model/event.dart';
import '../profile/model/user_profile.dart';

class GetEventsService {
  static Future<List<Event>> getEvents(int? userId, List<String>? categories,
      String orderBy, String orderDirection, int page) async {
    // Construct query parameters
    final queryParameters = {
      if (userId != null) 'user_id': userId.toString(),
      'order_by': orderBy,
      'order_direction': orderDirection,
      'page': page.toString(),
      if (categories != null && categories.isNotEmpty)
        'categories':
            jsonEncode(categories), // Encode categories as a JSON array
    };

    final baseUrl = (userId == null)
        ? 'https://list-events.fleure.workers.dev/api/user-events/all'
        : 'https://list-events.fleure.workers.dev/api/user-events';

    final url = Uri.parse(baseUrl).replace(queryParameters: queryParameters);

    List<dynamic> events;
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          events = responseBody['outcomes'];
        } else {
          throw Exception('Failed to fetch events: ${responseBody['message']}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }

    return events.map((json) => Event.fromJson(json)).toList();
  }
}
