import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/share.dart';

class GetSharesService {
  static Future<List<Share>> getUserShares(
      int? userId,
      List<String>? categories,
      String orderBy,
      String orderDirection,
      int page) async {
    if (userId == null) {
      return [];
    }

    final queryParameters = {
      'user_id': userId.toString(),
      'order_by': orderBy,
      'order_direction': orderDirection,
      'page': page.toString(),
      if (categories != null && categories.isNotEmpty)
        'categories':
            jsonEncode(categories), // Encode categories as a JSON array
    };
    final url =
        Uri.parse('https://list-shares.fleure.workers.dev/api/user-shares/all?')
            .replace(queryParameters: queryParameters);

    print(url);

    List<dynamic> shares;
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          shares = responseBody['outcomes'];
        } else {
          throw Exception('Failed to fetch events: ${responseBody['message']}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }

    return shares.map((json) => Share.fromJson(json)).toList();
  }
}
