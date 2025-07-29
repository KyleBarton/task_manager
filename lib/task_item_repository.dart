
import 'package:task_manager/project.dart';
import 'package:task_manager/result.dart';
import 'package:task_manager/task_item.dart';

enum RepositoryError {
  notFound,
  couldNotCreate,
}

class TaskItemRepository {

  // Just doing a very basic in-memory DB for now
  final Map<int, TaskItem> _inMemoryTasks = {};
  final Map<int, Project> _inMemoryProjects = {};
  int _latestTaskId = -1;
  int _latestProjectId = -1;

  Result<TaskItem, RepositoryError> getById(int id) {
    if (_inMemoryTasks.containsKey(id)) {
      return Ok(_inflate(_inMemoryTasks[id]!));
    } else {
      return Err(RepositoryError.notFound);
    }
  }

  Result<TaskItem, RepositoryError> create({
    required String title,
    String? project,
    String? category,
    String? content,
    TaskStatus status = TaskStatus.inbox})
  {
    _latestTaskId++;
    // TODO taskitem.of?
    final TaskItem item = TaskItem.create(title: title, project: project, content: content, category: category, id: _latestTaskId, status: status);
    _inMemoryTasks[_latestTaskId] = item;
    return Ok(_inflate(item));
  }

  Result<void, RepositoryError> update(TaskItem taskItem){
    if (_inMemoryTasks.containsKey(taskItem.id)) {
      _inMemoryTasks[taskItem.id] = _inflate(taskItem);
      return Ok(null);
    } else {
      return Err(RepositoryError.notFound);
    }
  }

  Result<List<TaskItem>, RepositoryError> getAllTasks() {
    return Ok(
        _inMemoryTasks.entries
            .map((entry) => _inflate(entry.value))
            .toList()
    );
  }

  Result<Project, RepositoryError> createProject(
      {
        required String title,
        required String purpose,
        required String outcomes,
        required String brainstorming,
        required String organization,
        required String referenceData,
        required List<TaskItem> tasks
      }) {
    _latestProjectId++;
    final project = Project.create(
      title: title,
      purpose: purpose,
      outcomes: outcomes,
      brainstorming: brainstorming,
      organization: organization,
      referenceData: referenceData,
      tasks: tasks,
      id: _latestProjectId,
    );
    _inMemoryProjects[_latestProjectId] = project;

    return Ok(_inflateProject(project));
  }


  Result<Project, RepositoryError> getProjectById(int id) {
    if (_inMemoryProjects.containsKey(id)) {
      return Ok(_inflateProject(_inMemoryProjects[id]!));
    }
    return Err(RepositoryError.notFound);
  }

  // Copying over to avoid in-memory pass-by-reference for now
  // In a real storage scenario, the item will be serialized and this won't be an issue
  TaskItem _inflate(TaskItem item) {
    return TaskItem.create(
        title: item.title,
        project: item.project,
        content: item.content,
        category: item.category,
        id: item.id,
        status: item.status
    );
  }
  Project _inflateProject(Project project) {
    return Project.create(title: project.title, purpose: project.purpose, outcomes: project.outcomes, brainstorming: project.brainstorming, organization: project.organization, referenceData: project.referenceData, tasks: project.tasks, id: project.id);
  }

  // TODO this is a temporary measure to give us some useful data at runtime
  void createInitialTasks() {
    List<TaskItem> nextActions = [
      TaskItem.create(
          title: "Research the foo",
          project: "foo",
          content: "do some online research for how to foo",
          category: "online-research-15min",
          id: 0,
          status: TaskStatus.nextAction),
      TaskItem.create(
          title: "Do the foo",
          project: "foo",
          content: "Foo around the house",
          category: "house-chores",
          id: 0,
          status: TaskStatus.nextAction),
      TaskItem.create(
          title: "Research the bar",
          project: "bar",
          content: "do some online research for how to bar",
          category: "online-research-15min",
          id: 0,
          status: TaskStatus.nextAction),
      TaskItem.create(
          title: "Do the bar",
          project: "bar",
          content: "bar around the house",
          category: "house-chores",
          id: 0,
          status: TaskStatus.nextAction),
    ];
    for (var task in nextActions) {
      create(title: task.title, project: task.project, category: task.category, content: task.content, status: task.status);
    }
    List<TaskItem> waitingFors = [
      TaskItem.create(
          title: "Texted Z about the foo",
          project: "foo",
          content: "Z might know something about the foo",
          category: "agenda-z",
          id: 0,
          status: TaskStatus.waitingFor),
      TaskItem.create(
          title: "Texted Z about the bar",
          project: "bar",
          content: "Z might know something about the bar",
          category: "agenda-z",
          id: 0,
          status: TaskStatus.waitingFor),
    ];
    for (var task in waitingFors) {
      create(title: task.title, project: task.project, category: task.category, content: task.content, status: task.status);
    }
    List<TaskItem> somedayMaybes = [
      TaskItem.create(
          title: "Write a book about foo",
          project: "foo",
          content: "it would be fun to write a book about what I've learned",
          category: null,
          id: 0,
          status: TaskStatus.somedayMaybe),
      TaskItem.create(
          title: "Write a book about bar",
          project: "bar",
          content: "it would be fun to write a book about what I've learned",
          category: null,
          id: 0,
          status: TaskStatus.somedayMaybe),
    ];
    for (var task in somedayMaybes) {
      create(title: task.title, project: task.project, category: task.category, content: task.content, status: task.status);
    }
    List<TaskItem> inboxes = [
      TaskItem.create(title: "Some stuff", project: null, content: null, category: null, id: 0, status: TaskStatus.inbox),
      TaskItem.create(title: "Some other stuff", project: null, content: null, category: null, id: 0, status: TaskStatus.inbox),
      TaskItem.create(title: "Inbox it", project: null, content: null, category: null, id: 0, status: TaskStatus.inbox),
      TaskItem.create(title: "Moar stuff", project: null, content: null, category: null, id: 0, status: TaskStatus.inbox),
    ];
    for (var task in inboxes) {
      create(title: task.title, project: task.project, category: task.category, content: task.content, status: task.status);
    }
  }

}
