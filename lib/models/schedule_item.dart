class ScheduleItem {
  final String scheduleId;
  final String groupId;
  final String groupName;
  final int dayOfWeek;
  final String startTime;
  final String endTime;

  ScheduleItem({
    required this.scheduleId,
    required this.groupId,
    required this.groupName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });
}

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
}