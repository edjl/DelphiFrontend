import 'package:flutter/material.dart';

class Option {
  String title = "";
  int positiveShares = 0;
  int negativeShares = 0;
  int marketCap = 0;
  int positivePrice = 0;
  int negativePrice = 0;
  String? imageLink = "";
  int userBought = 0;

  // Constructor for options
  Option(
      {required this.title,
      required this.positiveShares,
      required this.negativeShares,
      required this.marketCap,
      required this.positivePrice,
      required this.negativePrice,
      required this.imageLink,
      required this.userBought});

  // Factory constructor to create an Event object from JSON
  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      title: json['title'],
      positiveShares: json['positive_shares'],
      negativeShares: json['negative_shares'],
      marketCap: json['market_cap'],
      positivePrice: json['positive_price'],
      negativePrice: json['negative_price'],
      imageLink: json['image_link'],
      userBought: json['user_bought'] ?? 0,
    );
  }
}
