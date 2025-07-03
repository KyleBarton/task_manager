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