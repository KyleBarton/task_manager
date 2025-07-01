
import 'package:task_manager/result.dart';
import 'package:task_manager/task_item.dart';

enum RepositoryError {
  notFound,
  couldNotCreate,
}

class TaskItemRepository {

  // Just doing a very basic in-memory DB for now
  final Map<int, TaskItem> _inMemoryTasks = {};
  int _latestTaskId = -1;

  Result<TaskItem, RepositoryError> getById(int id) {
    if (_inMemoryTasks.containsKey(id)) {
      return Ok(_inMemoryTasks[id]!);
    } else {
      return Err(RepositoryError.notFound);
    }
  }

  // TODO error code as needed
  int saveNewTask(TaskItem taskItem) {
    _latestTaskId++;
    taskItem.id = _latestTaskId;
    _inMemoryTasks[_latestTaskId] = taskItem;
    return _latestTaskId;
  }

  Result<TaskItem, RepositoryError> create({
    required String title,
    String? project,
    String? category,
    String? content,
    TaskStatus status = TaskStatus.inbox})
  {
    _latestTaskId++;
    final TaskItem item = TaskItem.create(title: title, project: project, content: content, category: category, id: _latestTaskId, status: status);
    _inMemoryTasks[_latestTaskId] = item;
    return Ok(item);
  }
}