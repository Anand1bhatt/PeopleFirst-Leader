enum TaskPriority { high, medium, low }

enum TaskSource { azure, self }

enum TaskDue { today, tomorrow, thisWeek, later }

class TaskItem {
  final String id;
  final String title;
  final TaskPriority priority;
  final TaskSource source;
  final TaskDue due;
  final bool completed;
  final String dueLabel;

  const TaskItem({
    required this.id,
    required this.title,
    required this.priority,
    required this.source,
    required this.due,
    this.completed = false,
    required this.dueLabel,
  });

  TaskItem copyWith({
    String? id,
    String? title,
    TaskPriority? priority,
    TaskSource? source,
    TaskDue? due,
    bool? completed,
    String? dueLabel,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      source: source ?? this.source,
      due: due ?? this.due,
      completed: completed ?? this.completed,
      dueLabel: dueLabel ?? this.dueLabel,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
