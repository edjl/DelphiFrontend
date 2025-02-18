import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/option.dart';

class GetOptionsService {
  static Future<List<Option>> getOptions(int? userId, String eventName) async {
    // Construct query parameters
    final queryParameters = {
      if (userId != null) 'user_id': userId.toString(),
      'event_name': eventName,
    };

    final baseUrl = (userId == null)
        ? 'https://list-options.fleure.workers.dev/api/user-options/all'
        : 'https://list-options.fleure.workers.dev/api/user-options';

    final url = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
    print(url);

    List<dynamic> options;
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          options = responseBody['outcomes'];
        } else {
          throw Exception('Failed to fetch events: ${responseBody['message']}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }

    return options.map((json) => Option.fromJson(json)).toList();
  }
}
