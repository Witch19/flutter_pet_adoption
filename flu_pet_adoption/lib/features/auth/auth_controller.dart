import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthController {
  static const String baseUrl =
      'https://pet-adoption-api.desarrollo-software.xyz/api';

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(
        'Error al registrar usuario. Por favor inténtelo nuevamente',
      );
    }
  }
}
