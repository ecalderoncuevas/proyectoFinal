// import 'package:proyecto_final_synquid/core/constants/api_constants.dart';
// import 'package:proyecto_final_synquid/models/student.dart';
// import 'package:proyecto_final_synquid/services/api_client.dart';

// class StudentService {
//   final ApiClient _client;

//   StudentService(this._client);

//   Future<List<Student>> getGroupStudents(String groupId) async {
//     try {
//       final response = await _client.dio
//           .get(ApiConstants.teacherGroupStudents(groupId));
//       final list = response.data as List<dynamic>;
//       return list
//           .map((e) => Student.fromJson(e as Map<String, dynamic>))
//           .toList();
//     } catch (e) {
//       rethrow;
//     }
//   }
// }