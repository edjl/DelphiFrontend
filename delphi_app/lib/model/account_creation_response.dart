class AccountCreationResponse {
  final bool success;
  final String result;

  AccountCreationResponse({required this.success, required this.result});

  factory AccountCreationResponse.fromJson(Map<String, dynamic> json) {
    return AccountCreationResponse(
      success: json['success'],
      result: json['result'],
    );
  }
}
