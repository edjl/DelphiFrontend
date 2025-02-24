class Share {
  String eventName = "";
  String optionName = "";
  int shares = 0; // Negative means no, positive means yes
  int price = 0;
  int currentPrice = 0;
  String? imageLink = "";
  int purchaseDateTime = 0;
  int eventEndDateTime = 0;

  // Constructor for options
  Share(
      {required this.eventName,
      required this.optionName,
      required this.shares,
      required this.price,
      required this.currentPrice,
      required this.imageLink,
      required this.purchaseDateTime,
      required this.eventEndDateTime});

  // Factory constructor to create an Event object from JSON
  factory Share.fromJson(Map<String, dynamic> json) {
    return Share(
      eventName: json['event_name'],
      optionName: json['option_name'],
      purchaseDateTime: json['purchase_date_time'],
      eventEndDateTime: json['event_end_date'],
      shares: json['shares'],
      price: json['price'],
      currentPrice: json['current_price'],
      imageLink: json['image_link'],
    );
  }
}
