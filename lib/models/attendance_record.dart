class AttendanceRecord {
  final String groupId;
  final String groupName;
  final String date;
  final int status;

  AttendanceRecord({
    required this.groupId,
    required this.groupName,
    required this.date,
    required this.status,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) =>
      AttendanceRecord(
        groupId: (json['groupId'] ?? '').toString(),
        groupName: (json['groupName'] ?? '').toString(),
        date: (json['date'] ?? '').toString(),
        status: (json['status'] as num?)?.toInt() ?? 0,
      );
}

class Attendance {
  final String id;
  final String date;
  final String groupId;
  final String groupName;
  final String scheduleId;
  final String startTime;
  final String endTime;
  final int status;
  final String createdAt;
  final String userId;

  Attendance({
    required this.id,
    required this.date,
    required this.groupId,
    required this.groupName,
    required this.scheduleId,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
    required this.userId,
  });

  String get hora => startTime;

  String get fecha {
    try {
      final dt = DateTime.parse(date);
      final d = dt.day.toString().padLeft(2, '0');
      final m = dt.month.toString().padLeft(2, '0');
      final y = dt.year.toString();
      return '$d-$m-$y';
    } catch (_) {
      return date;
    }
  }

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: (json['id'] ?? '').toString(),
      date: (json['date'] ?? '').toString(),
      groupId: (json['groupId'] ?? '').toString(),
      groupName: (json['groupName'] ?? '').toString(),
      scheduleId: (json['scheduleId'] ?? '').toString(),
      startTime: (json['startTime'] ?? '').toString(),
      endTime: (json['endTime'] ?? '').toString(),
      status: (json['status'] as num?)?.toInt() ?? 0,
      createdAt: (json['createdAt'] ?? '').toString(),
      userId: json['userId'] ?? '',
    );
  }
}

class AttendanceHistoryItem {
  final String id;
  final String date;
  final int status;
  final String timestampLocal;

  AttendanceHistoryItem({
    required this.id,
    required this.date,
    required this.status,
    required this.timestampLocal,
  });

  String get hora {
    try {
      final dt = DateTime.parse(timestampLocal);
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    } catch (_) {
      if (timestampLocal.length >= 16) return timestampLocal.substring(11, 16);
      return '--:--';
    }
  }

  String get fecha {
    try {
      final dt = DateTime.parse(date);
      final d = dt.day.toString().padLeft(2, '0');
      final m = dt.month.toString().padLeft(2, '0');
      final y = dt.year.toString();
      return '$d-$m-$y';
    } catch (_) {
      return date;
    }
  }

  factory AttendanceHistoryItem.fromJson(Map<String, dynamic> json) =>
      AttendanceHistoryItem(
        id: (json['id'] ?? '').toString(),
        date: (json['date'] ?? '').toString(),
        status: (json['status'] as num?)?.toInt() ?? 0,
        timestampLocal:
            (json['timestampLocal'] ?? json['date'] ?? '').toString(),
      );
}

class TodayAttendance {
  final String userId;
  final int status;

  TodayAttendance({required this.userId, required this.status});

  factory TodayAttendance.fromJson(Map<String, dynamic> json) =>
      TodayAttendance(
        userId: (json['userId'] ?? '').toString(),
        status: (json['status'] as num?)?.toInt() ?? 1,
      );
}

class AttendanceResponse {
  final int codigoError;
  final String from;
  final String to;
  final int page;
  final int limit;
  final int total;
  final List<Attendance> attendances;
  final String timestamp;

  AttendanceResponse({
    required this.codigoError,
    required this.from,
    required this.to,
    required this.page,
    required this.limit,
    required this.total,
    required this.attendances,
    required this.timestamp,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      codigoError: json['codigoError'],
      from: json['from'],
      to: json['to'],
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      attendances: (json['attendances'] as List)
          .map((e) => Attendance.fromJson(e))
          .toList(),
      timestamp: json['timestamp'],
    );
  }
}