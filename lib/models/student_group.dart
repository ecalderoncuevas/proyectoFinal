// Grupo al que pertenece el alumno; devuelto por /student/myGroups
// Incluye el profesor responsable del grupo para mostrarlo en la UI
class StudentGroup {
  final String groupId;
  final String groupName;
  final String level;        // Nivel educativo 
  final String institutionId;
  final String professorId;
  final String professorName;

  StudentGroup({
    required this.groupId,
    required this.groupName,
    required this.level,
    required this.institutionId,
    required this.professorId,
    required this.professorName,
  });

  factory StudentGroup.fromJson(Map<String, dynamic> json) => StudentGroup(
        groupId: (json['groupId'] ?? '').toString(),
        groupName: (json['groupName'] ?? '').toString(),
        level: (json['level'] ?? '').toString(),
        institutionId: (json['institutionId'] ?? '').toString(),
        professorId: (json['professorId'] ?? '').toString(),
        professorName: (json['professorName'] ?? '').toString(),
      );
}