import 'dart:convert';
import 'package:flutter/material.dart';
import './share_model.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ShareController {
  Future<List<ShareModel>> getShares() async {
    const url =
        'https://list-shares.fleure.workers.dev/#/user-shares/get_ListUserShares'; // Replace with your URL
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns a successful response
      var jsonResponse = jsonDecode(response.body);
      debugPrint(jsonResponse); // Output the JSON response
      return [];
    } else {
      // If the server returns an error response
      debugPrint('Request failed with status: ${response.statusCode}');
      // return empty list
      return [];
    }
  }

  String getPercentChange(ShareModel share) {
    var value =
        (((share.currentValue - share.purchasePrice) / share.purchasePrice) *
            100);
    if (value > 0) {
      return '+ ${value.toStringAsFixed(1)}%';
    }
    return '- ${value.toStringAsFixed(1)}%';
  }

  String getCreditChange(ShareModel share) {
    var value =
        (share.currentValue - share.purchasePrice) * share.numberOfShares;
    if (value > 0) {
      return '+ ${NumberFormat('#,###').format(value)} credits';
    }
    return '- ${NumberFormat('#,###').format(value)} credits';
  }
}
