import 'package:dio/dio.dart';
import '../../models/pet_model.dart';
import '../network/api_client.dart';

class PetService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Pet>> getPets() async {
    try {
      final response = await _apiClient.dio.get('/pets/');
      
      print("--- RESPUESTA API PETS ---");
      print(response.data); 
      print("--------------------------");

      List<dynamic> data;

      if (response.data is Map<String, dynamic> && response.data.containsKey('results')) {
        data = response.data['results'];
      } 
      else if (response.data is List) {
        data = response.data;
      } 
      else {
        print("Formato de respuesta desconocido");
        return [];
      }
      
      return data.map((json) {
        try {
          return Pet.fromJson(json);
        } catch (e) {
          print("Error parseando mascota ID ${json['id']}: $e");
          return null;
        }
      }).whereType<Pet>().toList();

    } catch (e) {
      print("Error General obteniendo mascotas: $e");
      return []; 
    }
  }
  Future<bool> updatePetStatus(int petId, String newStatus) async {
    try {
      await _apiClient.dio.patch('/pets/$petId/', data: {
        "status": newStatus,
      });
      return true;
    } catch (e) {
      print("Error actualizando estado de mascota $petId: $e");
      return false;
    }
  }
  Future<bool> createPet(Map<String, dynamic> petData) async {
    try {
      await _apiClient.dio.post('/pets/', data: petData);
      return true;
    } catch (e) {
      print("Error creando mascota: $e");
      return false;
    }
  }

  Future<bool> updatePet(int id, Map<String, dynamic> petData) async {
    try {
      await _apiClient.dio.put('/pets/$id/', data: petData);
      return true;
    } catch (e) {
      print("Error actualizando mascota: $e");
      return false;
    }
  }
  
  Future<bool> deletePet(int id) async {
    try {
      await _apiClient.dio.delete('/pets/$id/');
      return true;
    } catch (e) {
      print("Error eliminando mascota: $e");
      return false;
    }
  }

  Future<Pet?> getPetById(int id) async {
    try {
      final response = await _apiClient.dio.get('/pets/$id/');
      return Pet.fromJson(response.data);
    } catch (e) {
      print("Error obteniendo mascota $id: $e");
      return null;
    }
  }
}