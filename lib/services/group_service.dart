import 'package:proyecto_final_synquid/core/constants/api_constants.dart';
import 'package:proyecto_final_synquid/models/group_schedule.dart';
import 'package:proyecto_final_synquid/services/api_client.dart';

class GroupService {
  final ApiClient _client;

  GroupService(this._client);

  Future<List<GroupSchedule>> getGroupSchedules(String groupId) async {
    try {
      final response =
          await _client.dio.get(ApiConstants.groupSchedules(groupId));
      final data = response.data as Map<String, dynamic>;
      final list = data['schedules'] as List<dynamic>;
      return list
          .map((e) => GroupSchedule.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}