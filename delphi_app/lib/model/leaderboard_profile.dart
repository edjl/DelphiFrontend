class LeaderboardProfile {
  String username = "";
  int balance = 0; // Negative means no, positive means yes
  int totalCreditsWon = 0;

  // Constructor for options
  LeaderboardProfile({
    required this.username,
    required this.balance,
    required this.totalCreditsWon,
  });

  // Factory constructor to create an Event object from JSON
  factory LeaderboardProfile.fromJson(Map<String, dynamic> json) {
    return LeaderboardProfile(
      username: json['username'],
      balance: json['balance'],
      totalCreditsWon: json['totalCreditsWon'],
    );
  }
}
