enum TaskStatus {
  inbox,
  nextAction,
  waitingFor,
  somedayMaybe,
  done,
}

class TaskItem {
  TaskItem({required this.title, this.status = TaskStatus.inbox});
  TaskStatus status;
  String title;
  String? content;
  String? project;
  String? category;
}
