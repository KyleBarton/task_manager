import 'package:flutter/material.dart';
import 'package:task_manager/task_item.dart';


class TaskItemPage extends StatefulWidget {
  final TaskItem item;
  const TaskItemPage({
    super.key,
    required this.item,
  });

  @override
  State<StatefulWidget> createState() => _TaskItemPageState();

}

class _TaskItemPageState extends State<TaskItemPage> {
  @override
  Widget build(BuildContext context) {
    var taskItem = widget.item;
    final TextEditingController itemContentController = TextEditingController(text: taskItem.content);
    final TextEditingController itemProjectController = TextEditingController(text: taskItem.project);
    final TextEditingController itemCategoryController = TextEditingController(text: taskItem.category);
    final TextEditingController itemTitleController = TextEditingController(text: taskItem.title);
    return Scaffold(
      appBar: AppBar(
        title: Hero(
            tag: "hero-item-id-${taskItem.id}",
            child: Material(
                type: MaterialType.transparency,
                child: TextField(controller: itemTitleController)
            )
        ),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          SegmentedButton<TaskStatus>(
            segments: [
              ButtonSegment(
                value: TaskStatus.inbox,
                label: Text(TaskStatus.inbox.toString()),
              ),
              ButtonSegment(
                value: TaskStatus.nextAction,
                label: Text(TaskStatus.nextAction.toString()),
              ),
              ButtonSegment(
                value: TaskStatus.waitingFor,
                label: Text(TaskStatus.waitingFor.toString()),
              ),
              ButtonSegment(
                value: TaskStatus.somedayMaybe,
                label: Text(TaskStatus.somedayMaybe.toString()),
              ),
            ],
            selected: {taskItem.status},
            emptySelectionAllowed: false,
            onSelectionChanged: (selection) => setState(() {
              taskItem.status = selection.first;
            }),
          ),
          TextField(
            controller: itemContentController,
            decoration: const InputDecoration(labelText: "Content"),
          ),
          TextField(
            controller: itemProjectController,
            decoration: const InputDecoration(labelText: "Project"),
          ),
          TextField(
            controller: itemCategoryController,
            decoration: const InputDecoration(labelText: "Category"),
          ),
          ElevatedButton(
              onPressed: () {
                taskItem
                  ..title = itemTitleController.text
                  ..content = itemContentController.text
                  ..project = itemProjectController.text
                  ..category = itemCategoryController.text;
                Navigator.pop(context, true);
              },
              child: Icon(Icons.save))
        ],
      ),
    );
  }
}
