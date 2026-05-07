// Grupo asignado al profesor; devuelto por /teacher/myGroups
// Incluye el número de alumnos del grupo (no disponible en StudentGroup)
class TeacherGroup {
  final String groupId;
  final String groupName;
  final String level;
  final String institutionId;
  final int studentCount; // Total de alumnos matriculados en el grupo

  TeacherGroup({
    required this.groupId,
    required this.groupName,
    required this.level,
    required this.institutionId,
    required this.studentCount,
  });

  factory TeacherGroup.fromJson(Map<String, dynamic> json) => TeacherGroup(
        groupId: (json['groupId'] ?? '').toString(),
        groupName: (json['groupName'] ?? '').toString(),
        level: (json['level'] ?? '').toString(),
        institutionId: (json['institutionId'] ?? '').toString(),
        studentCount: (json['studentCount'] as num?)?.toInt() ?? 0,
      );
}