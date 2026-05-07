import 'package:proyecto_final_synquid/core/constants/api_constants.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';
import 'package:proyecto_final_synquid/models/institution.dart';

// Proporciona acceso a la lista de instituciones educativas disponibles
class InstitutionService {
  final ApiClient _client;

  InstitutionService(this._client);

  // Descarga todas las instituciones para poblar el dropdown de SelectInstitutionScreen
  Future<List<Institution>> getAll() async {
    try {
      final response = await _client.dio.get(ApiConstants.institutions);
      final List<dynamic> data = response.data;
      return data.map((json) => Institution.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Obtiene los detalles de una institución concreta por su id
  Future<Institution> getById(String id) async {
    try {
      final response =
          await _client.dio.get('${ApiConstants.institutions}/$id');
      return Institution.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
