import 'package:flutter/material.dart';

class UserProfile {
  // Singleton pattern: Ensuring only one instance of UserProfile exists.
  static final UserProfile _instance = UserProfile._internal();

  // Factory constructor to provide access to the Singleton instance.
  factory UserProfile() {
    return _instance;
  }

  // Private constructor to prevent external instantiation.
  UserProfile._internal();

  // User profile fields
  ValueNotifier<int> _userId = ValueNotifier(-1);
  ValueNotifier<int> get userId =>
      _userId; // Exposing userId as a ValueNotifier
  String username = "DefaultUser";
  bool isAdmin = false;
  int balance = 0;
  int bankruptcyCount = 0;
  int totalBets = 0;
  int currentBets = 0;
  int totalCreditsPlaying = 0;
  int totalCreditsBet = 0;
  int totalCreditsWon = 0;
  bool premiumAccount = false;
  int profitMultiplier = 100;
  bool isLoggedIn = false; // Flag to check if the user is logged in.

  // Method to login and update user information
  void login({
    required int userId,
    required String username,
    required bool isAdmin,
    required int balance,
    required int bankruptcyCount,
    required int totalBets,
    required int currentBets,
    required int totalCreditsPlaying,
    required int totalCreditsBet,
    required int totalCreditsWon,
    required bool premiumAccount,
    required int profitMultiplier,
  }) {
    this._userId.value = userId; // Update the userId with ValueNotifier
    this.username = username;
    this.isAdmin = isAdmin;
    this.balance = balance;
    this.bankruptcyCount = bankruptcyCount;
    this.totalBets = totalBets;
    this.currentBets = currentBets;
    this.totalCreditsPlaying = totalCreditsPlaying;
    this.totalCreditsBet = totalCreditsBet;
    this.totalCreditsWon = totalCreditsWon;
    this.premiumAccount = premiumAccount;
    this.profitMultiplier = profitMultiplier;
    this.isLoggedIn = true;
  }

  // Method to create a new user
  void signup({
    required String username
  }) {
    this.username = username;
    this.isLoggedIn = true;
  }

  // Method to log out the user.
  void logOut() {
    this._userId.value = -1;
    this.username = "DefaultUser";
    this.isAdmin = false;
    this.balance = 0;
    this.bankruptcyCount = 0;
    this.totalBets = 0;
    this.currentBets = 0;
    this.totalCreditsPlaying = 0;
    this.totalCreditsBet = 0;
    this.totalCreditsWon = 0;
    this.premiumAccount = false;
    this.profitMultiplier = 100;
    this.isLoggedIn = false;
  }
}
