import 'package:flutter/material.dart';
import 'package:task_manager/task_item.dart';

class TaskItemPage extends StatelessWidget {
  final TaskItem taskItem;
  const TaskItemPage({
    super.key,
    required this.taskItem,
  });

  // TODO I think a segmentedButton could be good for changing TODO status:
  // https://api.flutter.dev/flutter/material/SegmentedButton-class.html
  @override
  Widget build(BuildContext context) {
    final TextEditingController itemContentController = TextEditingController(text: taskItem.content);
    final TextEditingController itemProjectController = TextEditingController(text: taskItem.project);
    final TextEditingController itemCategoryController = TextEditingController(text: taskItem.category);
    final TextEditingController itemTitleController = TextEditingController(text: taskItem.title);
    return Scaffold(
      appBar: AppBar(
        title: TextField(controller: itemTitleController),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
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

// A contained widget that facilitates navigation to the TaskItem drill-down.
// TODO maybe this goes in another file too?
class TaskItemAction extends StatelessWidget {
  final TaskItem taskItem;
  final void Function(TaskItem) stateCallback;

  const TaskItemAction({super.key, required this.taskItem, required this.stateCallback});

  Future<void> _navToTaskItem(TaskItem item, BuildContext context) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => TaskItemPage(taskItem: item)));
    if (result == true) {
      stateCallback(item);
    }
  }

  @override
  Widget build(BuildContext context) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 30),
        // TODO I think a listtile will be better here:
        // https://api.flutter.dev/flutter/material/ListTile-class.html
        ActionChip(
          label: Text(taskItem.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )
          ),
          avatar: Icon(Icons.label_outline_rounded),
          onPressed: () => _navToTaskItem(taskItem, context),
        )
      ],
    );
}
