import 'package:dio/dio.dart';
import '../network/api_client.dart';

class AdoptionService {
  final ApiClient _apiClient = ApiClient();

  Future<bool> createAdoptionRequest(int userId, int petId) async {
    try {
      await _apiClient.dio.post('/adoption-requests/', data: {
        "user": userId,
        "pet": petId,
        "status": "Pendiente",
      });
      return true;
    } catch (e) {
      print("Error creando solicitud de adopción: $e");
      return false;
    }
  }

  Future<List<dynamic>> getMyAdoptionRequests(int userId) async {
    try {
      final response = await _apiClient.dio.get('/adoption-requests/');
      
      List<dynamic> allRequests = [];
      
      if (response.data is Map<String, dynamic> && response.data.containsKey('results')) {
        allRequests = response.data['results'];
      } else if (response.data is List) {
        allRequests = response.data;
      }

      return allRequests.where((req) => req['user'] == userId).toList();
      
    } catch (e) {
      print("Error obteniendo mis solicitudes: $e");
      return [];
    }
  }

  Future<List<dynamic>> getAllRequests() async {
    try {
      final response = await _apiClient.dio.get('/adoption-requests/');
    
      if (response.data is Map<String, dynamic> && response.data.containsKey('results')) {
        return response.data['results'];
      } else if (response.data is List) {
        return response.data;
      }
      return [];
    } catch (e) {
      print("Error obteniendo solicitudes: $e");
      return [];
    }
  }
  
  Future<bool> updateRequestStatus(int requestId, String newStatus) async {
    try {
      await _apiClient.dio.patch('/adoption-requests/$requestId/', data: {
        "status": newStatus,
      });
      return true;
    } catch (e) {
      print("Error actualizando solicitud $requestId: $e");
      return false;
    }
  }
}