import 'package:http/http.dart' as http;

class OptionService {
  static Future<bool> buyOption(
      int? userId, String eventName, String optionName, int shareCount) async {
    if (userId == null) {
      return false;
    }

    // Construct query parameters
    final queryParameters = {
      'user_id': userId.toString(),
      'event_name': eventName,
      'option_name': optionName,
      'share_count': shareCount.toString(),
    };

    final baseUrl = Uri.parse('https://buyer.fleure.workers.dev/api/BuyShares')
        .replace(queryParameters: queryParameters);

    final response = await http.post(
      baseUrl,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
    );

    return (response.statusCode == 200) ? true : false;
  }
}
