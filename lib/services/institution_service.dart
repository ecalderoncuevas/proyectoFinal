import 'package:proyecto_final_synquid/core/constants/api_constants.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';
import 'package:proyecto_final_synquid/models/institution.dart';

class InstitutionService {
  final ApiClient _client;

  InstitutionService(this._client);

  Future<List<Institution>> getAll() async {
    try {
      final response = await _client.dio.get(ApiConstants.institutions);
      final List<dynamic> data = response.data;
      return data.map((json) => Institution.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

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
