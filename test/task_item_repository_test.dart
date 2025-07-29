import 'dart:convert';

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
      // TODO probably need to fix this
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

    final allTasks = taskItemRepository.getAllTasks().expect();

    assert (allTasks.length == 3);
    assert (allTasks.where((item) => item.status == TaskStatus.inbox).length == 1);
    assert (allTasks.where((item) => item.status == TaskStatus.nextAction).length == 1);
    assert (allTasks.where((item) => item.status == TaskStatus.waitingFor).length == 1);
  });
  test("Can create and get a project by id", () {
    final createResult = taskItemRepository.createProject(
      title: "My New Project",
      purpose: "Some purpose & principals of the project",
      outcomes: "Desired outcomes, vision for the project",
      brainstorming: "Pie-in-the-sky ideas about the project",
      organization: "Timestamped notes about the project for reference",
      referenceData: "Data that might be helpful for the project",
      tasks: List.empty(),
    ).expect();

    final expectedProject = taskItemRepository.getProjectById(createResult.id).expect();

    assert(createResult.title == expectedProject.title);
    assert(createResult.purpose == expectedProject.purpose);
    assert(createResult.outcomes == expectedProject.outcomes);
    assert(createResult.brainstorming == expectedProject.brainstorming);
    assert(createResult.organization == expectedProject.organization);
    assert(createResult.referenceData == expectedProject.referenceData);
    assert(createResult.tasks == expectedProject.tasks);
  });
  test("Can update a project", () {
    final createResult = taskItemRepository.createProject(
      title: "My New Project",
      purpose: "Some purpose & principals of the project",
      outcomes: "Desired outcomes, vision for the project",
      brainstorming: "Pie-in-the-sky ideas about the project",
      organization: "Timestamped notes about the project for reference",
      referenceData: "Data that might be helpful for the project",
      tasks: List.empty(),
    ).expect();

    final projectToUpdate = taskItemRepository.getProjectById(createResult.id).expect();

  });
  test("Can save task to a project", () {});
  test("Can get all tasks in a project", (){});
  test("Can save task with no project", () {});
  test("Can encode Project to json", (){
    final project = taskItemRepository.createProject(title: "title", purpose: "purpose", outcomes: "outcomes", brainstorming: "brainstorming", organization: "organization", referenceData: "referenceData", tasks: List.empty()).expect();
    final encoded = jsonEncode(project);

    assert (encoded != null);
  });
}