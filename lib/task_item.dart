enum TaskStatus {
  inbox,
  nextAction,
  waitingFor,
  somedayMaybe,
  done,
}

class TaskItem {
  TaskItem.create({
    required this.title,
    required this.project,
    required this.content,
    required this.category,
    required this.id,
    required this.status,
  });
  TaskStatus status;
  String title;
  int id;
  String? content;
  String? project;
  String? category;
}
