class Event {
  String name = "";
  int shares = 0;
  int marketCap = 0;
  int endDate = 0;
  String topOptionTitle = "";
  int topOptionPrice = 0;
  String? topOptionImage;
  bool userBought = false;

  Event({
    required this.name,
    required this.shares,
    required this.marketCap,
    required this.endDate,
    required this.topOptionTitle,
    required this.topOptionPrice,
    required this.topOptionImage,
    required this.userBought,
  });

  // Factory constructor to create an Event object from JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'],
      shares: json['shares'],
      marketCap: json['market_cap'],
      endDate: json['end_date'],
      topOptionTitle: json['top_option_title'],
      topOptionPrice: json['top_option_price'],
      topOptionImage: json['top_option_image'],
      userBought: json['user_bought'] == 1 ? true : false,
    );
  }
}
