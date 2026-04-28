class StudentGroup {
  final String groupId;
  final String groupName;
  final String level;
  final String institutionId;
  final String professorId;

  StudentGroup({
    required this.groupId,
    required this.groupName,
    required this.level,
    required this.institutionId,
    required this.professorId,
  });

  factory StudentGroup.fromJson(Map<String, dynamic> json) => StudentGroup(
        groupId: (json['groupId'] ?? '').toString(),
        groupName: (json['groupName'] ?? '').toString(),
        level: (json['level'] ?? '').toString(),
        institutionId: (json['institutionId'] ?? '').toString(),
        professorId: (json['professorId'] ?? '').toString(),
      );
}