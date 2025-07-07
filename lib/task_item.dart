enum TaskStatus {
  inbox,
  nextAction,
  waitingFor,
  somedayMaybe,
  done;

  @override
  String toString() {
    switch (this) {
      case TaskStatus.inbox: return "Inbox";
      case TaskStatus.nextAction: return "Next Action";
      case TaskStatus.waitingFor: return "Waiting For";
      case TaskStatus.somedayMaybe: return "Someday/Maybe";
      case TaskStatus.done: return "Done";
      }
  }
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
