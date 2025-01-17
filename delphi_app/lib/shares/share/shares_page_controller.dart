import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './shares_page_model.dart';
import '../share_model.dart';

class SharePageController {
  SharePageModel sharePageModel = SharePageModel([]);

  Future<List<ShareModel>> getShares() async {
    const url =
        'https://list-shares.fleure.workers.dev/#/user-shares/get_ListUserShares'; // Replace with your URL
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns a successful response
      var jsonResponse = jsonDecode(response.body);
      debugPrint(jsonResponse); // Output the JSON response

      List<ShareModel> listOfShares = [];

      if (jsonResponse is Map<String, dynamic>) {
        // Iterate through the map using forEach
        jsonResponse.forEach((key, value) {
          // 'key' is the key, and 'value' is the JSON data for each share
          ShareModel share = ShareModel.fromJson(value);
          listOfShares.add(share);
        });
      }
      return listOfShares;
    } else {
      // If the server returns an error response
      debugPrint('Request failed with status: ${response.statusCode}');
      // return empty list
      return [];
    }
  }

  List<ShareModel> fuzzySearch(List<ShareModel> jsonList, String query) {
    List<ShareModel> matchedIndices = [];

    for (int i = 0; i < jsonList.length; i++) {
      String betQuestion = jsonList[i].betQuestion ?? '';
      String betAnswer = jsonList[i].betAnswer ?? '';
      int currentValue = jsonList[i].currentValue;
      DateTime? purchaseDate = jsonList[i].purchaseDate != null
          ? DateTime.parse(jsonList[i].purchaseDate)
          : null;
      DateTime? endDate = jsonList[i].endDate != null
          ? DateTime.parse(jsonList[i].endDate)
          : null;
      int numberOfShares = jsonList[i].numberOfShares;
      int purchasePrice = jsonList[i].purchasePrice;

      if (query.trim() == "") {
        // empty searches should always be added
        matchedIndices.add(jsonList[i]);
      } else if (betQuestion.toLowerCase().contains(query.toLowerCase()) ||
          betAnswer.toLowerCase().contains(query.toLowerCase()) ||
          (currentValue.toString().contains(query)) ||
          (purchaseDate != null && purchaseDate.toString().contains(query)) ||
          (endDate != null && endDate.toString().contains(query)) ||
          (numberOfShares.toString().contains(query)) ||
          (purchasePrice.toString().contains(query))) {
        matchedIndices.add(jsonList[i]);
      }
    }

    return matchedIndices;
  }

  // void addShare(ShareModel share) {
  //   sharePageModel.shares.add(share);
  // }

  // void removeShare(ShareModel share) {
  //   sharePageModel.shares.remove(share);
  // }
}
