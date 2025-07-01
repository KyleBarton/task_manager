// Just keeping these as strings for now, they can be designed better later
// TODO needs its actual state (e.g. IN, NEXTACTION, etc)
class TaskItem {
  TaskItem(this.title);
  String title;
  String? content;
  String? project;
  String? category;
}
