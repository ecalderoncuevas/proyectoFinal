// Franja horaria del horario del alumno; devuelto por /student/schedule
// dayOfWeek usa la convención de la API: 0=domingo, 1=lunes … 6=sábado
class ScheduleItem {
  final String scheduleId;
  final String groupId;
  final String groupName;
  final String professorName;
  final int dayOfWeek;
  final String startTime;
  final String endTime;

  ScheduleItem({
    required this.scheduleId,
    required this.groupId,
    required this.groupName,
    required this.professorName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) => ScheduleItem(
        scheduleId: (json['scheduleId'] ?? '').toString(),
        groupId: (json['groupId'] ?? '').toString(),
        groupName: (json['groupName'] ?? '').toString(),
        professorName: (json['professorName'] ?? '').toString(),
        dayOfWeek: (json['dayOfWeek'] as num?)?.toInt() ?? 0,
        startTime: (json['startTime'] ?? '').toString(),
        endTime: (json['endTime'] ?? '').toString(),
      );
}

// Franja horaria del horario del profesor; devuelto por /teacher/schedule
// Incluye el nivel del grupo en lugar del nombre del profesor (ya es el propio profesor)
class TeacherScheduleItem {
  final String scheduleId;
  final String groupId;
  final String groupName;
  final String level;
  final int dayOfWeek;
  final String startTime;
  final String endTime;

  TeacherScheduleItem({
    required this.scheduleId,
    required this.groupId,
    required this.groupName,
    required this.level,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory TeacherScheduleItem.fromJson(Map<String, dynamic> json) =>
      TeacherScheduleItem(
        scheduleId: (json['scheduleId'] ?? '').toString(),
        groupId: (json['groupId'] ?? '').toString(),
        groupName: (json['groupName'] ?? '').toString(),
        level: (json['level'] ?? '').toString(),
        dayOfWeek: (json['dayOfWeek'] as num?)?.toInt() ?? 0,
        startTime: (json['startTime'] ?? '').toString(),
        endTime: (json['endTime'] ?? '').toString(),
      );
}
