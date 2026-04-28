import 'package:proyecto_final_synquid/core/constants/api_constants.dart';
import 'package:proyecto_final_synquid/models/student_group.dart';
import 'package:proyecto_final_synquid/models/user.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';

class UserService {
  final ApiClient _client;

  UserService(this._client);

  Future<User> getMe() async {
    try {
      final response = await _client.dio.get(ApiConstants.userMe);
      return User.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<StudentGroup>> getUserGroups(String userId) async {
    try {
      final response =
          await _client.dio.get(ApiConstants.userGroups(userId));
      final data = response.data as Map<String, dynamic>;
      final list = data['groups'] as List<dynamic>;
      return list
          .map((e) => StudentGroup.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}