// Horario recurrente de un grupo con tolerancia de retraso
// Actualmente no se usa en pantallas activas; se mantiene para referencia futura
class GroupSchedule {
  final String scheduleId;
  final int dayOfWeek; // 0=Sun, 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat
  final String startTime;
  final String endTime;
  final int lateToleranceMinutes; // Minutos de gracia antes de marcar como tarde

  GroupSchedule({
    required this.scheduleId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.lateToleranceMinutes,
  });

  factory GroupSchedule.fromJson(Map<String, dynamic> json) => GroupSchedule(
        scheduleId: (json['scheduleId'] ?? '').toString(),
        dayOfWeek: (json['dayOfWeek'] as num?)?.toInt() ?? 0,
        startTime: (json['startTime'] ?? '').toString(),
        endTime: (json['endTime'] ?? '').toString(),
        lateToleranceMinutes:
            (json['lateToleranceMinutes'] as num?)?.toInt() ?? 0,
      );
}