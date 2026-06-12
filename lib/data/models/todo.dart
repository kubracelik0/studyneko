class Todo {
  final int? id;
  final String title;
  final bool isCompleted;
  final String date;
  final String? subject;

  Todo({
    this.id,
    required this.title,
    this.isCompleted = false,
    required this.date,
    this.subject,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'is_completed': isCompleted ? 1 : 0,
      'date': date,
      'subject': subject,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      isCompleted: map['is_completed'] == 1,
      date: map['date'],
      subject: map['subject'],
    );
  }

  // Kopyala ve güncelle
  Todo copyWith({bool? isCompleted, String? title}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date,
      subject: subject,
    );
  }
}