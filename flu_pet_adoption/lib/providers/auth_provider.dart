import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../core/network/api_client.dart';

enum AuthStatus { notAuthenticated, checking, authenticated }
enum UserRole { guest, user, admin }

class AuthProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  AuthStatus status = AuthStatus.checking;
  UserRole role = UserRole.guest;
  Map<String, dynamic>? userData;

  AuthProvider() {
    _checkSession();
  }

  Future<void> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    if (token != null && !JwtDecoder.isExpired(token)) {
      status = AuthStatus.authenticated;
      int userId = prefs.getInt('user_id') ?? 0;
      if (userId != 0) {
        await _fetchUserProfile(userId);
      }
    } else {
      logout();
    }
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await _apiClient.dio.post('/auth/login/', data: {
        "username": username,
        "password": password
      });

      final prefs = await SharedPreferences.getInstance();
      String accessToken = response.data['access'];
      
      await prefs.setString('access_token', accessToken);
      await prefs.setString('refresh_token', response.data['refresh']);
      
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
      
      int userId = int.tryParse(decodedToken['user_id'].toString()) ?? 0;
      
      await prefs.setInt('user_id', userId);

      userData = {'username': username, 'email': '', 'id': userId}; 
      
      status = AuthStatus.authenticated;
      
      await _fetchUserProfile(userId); 
      
      notifyListeners();
      return true;
    } catch (e) {
      print("Error en login: $e");
      status = AuthStatus.notAuthenticated;
      return false;
    }
  }

  Future<void> _fetchUserProfile(int userId) async {
    try {
      final response = await _apiClient.dio.get('/admin/users/$userId/');
      userData = response.data;
      bool isStaff = userData?['is_staff'] ?? false;
      role = isStaff ? UserRole.admin : UserRole.user;
    } catch (e) {
      print("No se pudo cargar perfil admin (probablemente es usuario normal): $e");
      role = UserRole.user;
    }
    notifyListeners();
  }
  
  Future<bool> register(String username, String email, String password) async {
    try {
      await _apiClient.dio.post('/auth/register/', data: {
        "username": username,
        "email": email,
        "password": password
      });
      return true;
    } catch (e) {
      print("Error en registro: $e");
      return false;
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    status = AuthStatus.notAuthenticated;
    role = UserRole.guest;
    userData = null;
    notifyListeners();
  }
}