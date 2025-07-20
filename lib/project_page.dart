import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/app_dependencies.dart';
import 'package:task_manager/result.dart';
import 'package:task_manager/task_item.dart';
import 'package:task_manager/task_item_page.dart';
import 'package:task_manager/task_item_repository.dart';
import 'package:task_manager/task_list_widget.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});
  @override
  State<StatefulWidget> createState() => _ProjectPageState();

}

class _ProjectPageState extends State<ProjectPage> {
  final List<TaskItem> _tasks = [];
  String _projectTitle = "";
  late final TaskItemRepository _taskItemRepository;

  @override
  void initState() {
    final dependencies = context.appDependencies();
    _taskItemRepository = dependencies.taskItemRepository;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_projectTitle == "" ? "New Project" : _projectTitle),
        backgroundColor: Colors.amber,
      ),
      body: Expanded(
        child: ListView(
          shrinkWrap: true,
          children: [
            TextField(
              // controller: itemContentController,
              decoration: const InputDecoration(labelText: "Title"),
              onChanged: (val) => setState(() {
                _projectTitle = val;
              }),
            ),
            TextField(
              // controller: itemContentController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(labelText: "Purpose & Principals"),
            ),
            TextField(
              // controller: itemContentController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(labelText: "Vision & Outcomes"),
            ),
            TextField(
              // controller: itemContentController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(labelText: "Brainstorming"),
            ),
            TextField(
              // controller: itemContentController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(labelText: "Organization"),
            ),
            TextField(
              // controller: itemContentController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(labelText: "Reference Data"),
            ),
            // TODO this is a list of tasks not a text field
            Text(
              "Future Work to Consider",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            taskListView(
              _tasks.where((t) => t.status == TaskStatus.somedayMaybe).toList(),
              context,
                  (item) => setState(() {
                _taskItemRepository.update(item);
              }),
            ),
            _addTask(TaskStatus.somedayMaybe),
            Text(
              "Next Actions",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            taskListView(
              _tasks.where((t) => t.status == TaskStatus.nextAction).toList(),
              context,
              ((item) => setState(() {
                _taskItemRepository.update(item);
              })),
            ),
            _addTask(TaskStatus.nextAction),
            Text(
              "Waiting For",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            taskListView(
                _tasks.where((t) => t.status == TaskStatus.waitingFor).toList(),
                context,
                ((item) => setState(() {
                  _taskItemRepository.update(item);
                })),
            ),
            _addTask(TaskStatus.waitingFor),
            Divider(),
            ElevatedButton(
                onPressed: () {
                  // TODO would be good to get a bulk updater function available
                  for (TaskItem task in _tasks) {
                    task.project = _projectTitle;
                    _taskItemRepository.update(task).expect();
                  }
                  Navigator.pop(context, true);
                },
                child: Icon(Icons.save))
          ],
        ),
      ),
    );
  }

  Widget _addTask(TaskStatus status) =>
      Row(
        children: [
          IconButton(
            onPressed: () async {
              // TODO handle result
              final newItem = _taskItemRepository.create(
                title: "Enter task title",
                status: status,
                project: _projectTitle,
                // TODO maybe tie it to project via project ID
              ).expect();
              final updated = await Navigator.push(context, MaterialPageRoute(builder: (context) => TaskItemPage(item: newItem)));
              if (updated == true) {
                setState((){
                  _taskItemRepository.update(newItem);
                  // TODO once project IDs are created, populate _tasks from the taskItemRepository
                  _tasks.add(newItem);
                });
              }
            },
            icon: Icon(Icons.add),
          ),
          Expanded(child: SizedBox())
        ],
      );
}