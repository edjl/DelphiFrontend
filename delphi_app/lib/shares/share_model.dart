class ShareModel {
  int? _id;
  String? _betQuestion;
  String? _betAnswer;
  int? _currentValue;
  DateTime? _purchaseDate;
  DateTime? _endDate;
  int? _numberOfShares;
  bool? _betIsYes;
  int? _purchasePrice;
  String? _imageURL;

  // Constructor
  ShareModel({
    required int? id,
    required String? betQuestion,
    required String? betAnswer,
    required int? currentValue,
    required DateTime? purchaseDate,
    required DateTime? endDate,
    required int? numberOfShares,
    required bool? betIsYes,
    required int? purchasePrice,
    required String? imageURL,
  })  : _id = id,
        _betQuestion = betQuestion,
        _betAnswer = betAnswer,
        _currentValue = currentValue,
        _purchaseDate = purchaseDate,
        _endDate = endDate,
        _numberOfShares = numberOfShares,
        _betIsYes = betIsYes,
        _purchasePrice = purchasePrice,
        _imageURL = imageURL;

  // Getters
  get id => _id;
  get betQuestion => _betQuestion;
  get betAnswer => _betAnswer;
  get currentValue => _currentValue;
  get purchaseDate => _purchaseDate;
  get endDate => _endDate;
  get numberOfShares => _numberOfShares;
  get betIsYes => _betIsYes;
  get purchasePrice => _purchasePrice;
  get imageURL => _imageURL;

  // Setters
  set id(newId) => _id = newId;
  set betQuestion(newBetQuestion) => _betQuestion = newBetQuestion;
  set betAnswer(newBetAnswer) => _betAnswer = newBetAnswer;
  set currentValue(newCurrentValue) => _currentValue = newCurrentValue;
  set purchaseDate(newPurchaseDate) => _purchaseDate = newPurchaseDate;
  set endDate(newEndDate) => _endDate = newEndDate;
  set numberOfShares(newNumberOfShares) => _numberOfShares = newNumberOfShares;
  set betIsYes(newBetIsYes) => _betIsYes = newBetIsYes;
  set purchasePrice(newPurchasePrice) => _purchasePrice = newPurchasePrice;
  set imageURL(newImageURL) => _imageURL = newImageURL;

  // toJson function
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'betQuestion': _betQuestion,
      'betAnswer': _betAnswer,
      'currentValue': _currentValue,
      'purchaseDate': _purchaseDate?.toIso8601String(),
      'endDate': _endDate?.toIso8601String(),
      'numberOfShares': _numberOfShares,
      'betIsYes': _betIsYes,
      'purchasePrice': _purchasePrice,
      'imageURL': _imageURL,
    };
  }

  // fromJson function
  factory ShareModel.fromJson(Map<String, dynamic> json) {
    return ShareModel(
      id: json['id'],
      betQuestion: json['betQuestion'],
      betAnswer: json['betAnswer'],
      currentValue: json['currentValue'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
      endDate: DateTime.parse(json['endDate']),
      numberOfShares: json['numberOfShares'],
      betIsYes: json['betIsYes'],
      purchasePrice: json['purchasePrice'],
      imageURL: json['imageURL'],
    );
  }
}
