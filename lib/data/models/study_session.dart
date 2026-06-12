class StudySession {
  final int? id;
  final String subject;
  final int duration;
  final String date;
  final String sessionType;
  final String createdAt;
  final String? notes; // 📝 YENİ

  StudySession({
    this.id,
    required this.subject,
    required this.duration,
    required this.date,
    required this.sessionType,
    required this.createdAt,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'duration': duration,
      'date': date,
      'session_type': sessionType,
      'created_at': createdAt,
      'notes': notes,
    };
  }

  factory StudySession.fromMap(Map<String, dynamic> map) {
    return StudySession(
      id: map['id'],
      subject: map['subject'],
      duration: map['duration'],
      date: map['date'],
      sessionType: map['session_type'],
      createdAt: map['created_at'],
      notes: map['notes'],
    );
  }
}