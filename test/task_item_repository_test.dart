import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/result.dart';
import 'package:task_manager/task_item.dart';
import 'package:task_manager/task_item_repository.dart';

void main() {
  late TaskItemRepository taskItemRepository;
  setUp(() {
    taskItemRepository = TaskItemRepository();
  });
  test("Can Save and Retrieve Task by Id", () {

    final taskItem = taskItemRepository.create(
      title: "This is a task",
      project: "Proj1",
      content: "Some content",
      category: "chores",
    ).expect();

    final retrievedTaskItem = taskItemRepository.getById(taskItem.id).expect();

    assert (taskItem.status == retrievedTaskItem.status);
    assert (taskItem.title == retrievedTaskItem.title);
    assert (taskItem.project == retrievedTaskItem.project);
    assert (taskItem.category == retrievedTaskItem.category);
    assert (taskItem.content == retrievedTaskItem.content);
    assert (retrievedTaskItem.id == taskItem.id);
  });
  test("Can update Task by Id", () {
    final taskItem = taskItemRepository.create(title: "New Task").expect();
    taskItem.project = "I included the project";
    taskItem.status = TaskStatus.nextAction;
    taskItem.category = "house-chores";
    taskItem.content = "I added some content";

    taskItemRepository.update(taskItem).expect();

    final retrieved = taskItemRepository.getById(taskItem.id).expect();

    assert (retrieved.project == taskItem.project);
    assert (retrieved.status == taskItem.status);
    assert (retrieved.category == taskItem.category);
    assert (retrieved.content == taskItem.content);
  });
  test("Can get all tasks", () {
    taskItemRepository.create(title: "Test Inbox", status: TaskStatus.inbox).expect();
    taskItemRepository.create(title: "Test Next Action", status: TaskStatus.nextAction).expect();
    taskItemRepository.create(title: "Test Waiting For", status: TaskStatus.waitingFor).expect();

    final allTasks = taskItemRepository.getAll().expect();

    assert (allTasks.length == 3);
    assert (allTasks.where((item) => item.status == TaskStatus.inbox).length == 1);
    assert (allTasks.where((item) => item.status == TaskStatus.nextAction).length == 1);
    assert (allTasks.where((item) => item.status == TaskStatus.waitingFor).length == 1);
  });
}