import 'package:flutter/material.dart';

class Shares {
  int eventId = 0;
  int optionId = 0;
  int userId = 0;
  int purchaseDate = 0;
  int shares = 0;
  int price = 0;

  // Constructor for shares
  Shares({
    required this.eventId,
    required this.optionId,
    required this.userId,
    required this.purchaseDate,
    required this.shares,
    required this.price,
  });
}
