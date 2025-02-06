import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/option.dart';
import '../model/share.dart';

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

  static Future<List<Share>> getUserShares(
      int? userId, String eventName) async {
    if (userId == null) {
      return [];
    }

    final queryParameters = {
      'user_id': userId.toString(),
      'event_name': eventName,
    };

    final url =
        Uri.parse('https://list-shares.fleure.workers.dev/api/user-shares')
            .replace(queryParameters: queryParameters);

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

  static Future<bool> sellShares(int? userId, String eventName,
      String optionName, int purchaseDateTime, int shareCount) async {
    if (userId == null) {
      return false;
    }

    // Construct query parameters
    final queryParameters = {
      'user_id': userId.toString(),
      'event_name': eventName,
      'option_name': optionName,
      'purchase_date_time': purchaseDateTime.toString(),
      'shares_count': shareCount.toString(),
    };

    final baseUrl =
        Uri.parse('https://seller.fleure.workers.dev/api/SellShares')
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
