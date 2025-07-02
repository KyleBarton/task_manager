
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
  // Copying over to avoid in-memory pass-by-reference for now
  // In a real storage scenario, the item will be serialized and this won't be an issue
  _inflate(TaskItem item) {
    return TaskItem.create(
        title: item.title,
        project: item.project,
        content: item.content,
        category: item.category,
        id: item.id,
        status: item.status
    );
  }
}