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
      print('ERROR en getAll(): $e');
      rethrow;
    }
  }

  Future<Institution> getById(String id) async {
    final response = await _client.dio.get('${ApiConstants.institutions}/$id');
    return Institution.fromJson(response.data);
  }

  Future<Institution> create(Institution institution) async {
    final response = await _client.dio.post(
      ApiConstants.institutions,
      data: institution.toJson(),
    );
    return Institution.fromJson(response.data);
  }

  Future<Institution> update(String id, Institution institution) async {
    final response = await _client.dio.put(
      '${ApiConstants.institutions}/$id',
      data: institution.toJson(),
    );
    return Institution.fromJson(response.data);
  }

  Future<void> delete(String id) async {
    await _client.dio.delete('${ApiConstants.institutions}/$id');
  }
}