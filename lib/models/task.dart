class TaskTime {
  final int hour;
  final int minute;

  TaskTime({required this.hour, required this.minute});

  @override
  String toString() => '$hour:$minute';
}

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TaskTime? time;
  bool isCompleted;
  final String? category; // e.g., 'Exercise', 'Study', 'Prayer', 'Hydration'

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.time,
    this.isCompleted = false,
    this.category,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'time': time != null ? '${time!.hour}:${time!.minute}' : null,
      'isCompleted': isCompleted,
      'category': category,
    };
  }

  // Create from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      time: json['time'] != null
          ? TaskTime(
              hour: int.parse(json['time'].split(':')[0]),
              minute: int.parse(json['time'].split(':')[1]),
            )
          : null,
      isCompleted: json['is_completed'] ?? json['isCompleted'] ?? false,
      category: json['category'],
    );
  }
}

class TimeOfDay {
  final int hour;
  final int minute;

  TimeOfDay({required this.hour, required this.minute});

  String toTimeString() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
