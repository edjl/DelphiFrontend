class LoginResponse {
  final bool success;
  final int userId;

  LoginResponse({required this.success, required this.userId});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      userId: json['user_id'],
    );
  }
}
