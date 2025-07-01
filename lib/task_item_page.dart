import 'package:flutter/material.dart';
import 'package:task_manager/task_item.dart';

class TaskItemPage extends StatefulWidget {
  final TaskItem inboxItem;
  const TaskItemPage({super.key, required this.inboxItem});

  @override
  State<StatefulWidget> createState() => _TaskItemPageState();
}

// TODO should you be able to edit title? Probably
class _TaskItemPageState extends State<TaskItemPage> {
  late final TextEditingController _itemContentController;
  late final TextEditingController _itemProjectController;
  late final TextEditingController _itemCategoryController;
  late final TextEditingController _itemTitleController;
  @override
  void initState() {
    super.initState();
    final inboxItem = widget.inboxItem;
    _itemTitleController = TextEditingController(text: inboxItem.title);
    _itemContentController = TextEditingController(text: inboxItem.content);
    _itemProjectController = TextEditingController(text: inboxItem.project);
    _itemCategoryController = TextEditingController(text: inboxItem.category);
  }

  @override
  void dispose() {
    _itemContentController.dispose();
    _itemCategoryController.dispose();
    _itemProjectController.dispose();
    _itemTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(controller: _itemTitleController),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          TextField(
            controller: _itemContentController,
            decoration: const InputDecoration(labelText: "Content"),
          ),
          TextField(
            controller: _itemProjectController,
            decoration: const InputDecoration(labelText: "Project"),
          ),
          TextField(
            controller: _itemCategoryController,
            decoration: const InputDecoration(labelText: "Category"),
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.inboxItem
                    ..title = _itemTitleController.text
                    ..content = _itemContentController.text
                    ..project = _itemProjectController.text
                    ..category = _itemCategoryController.text;
                });
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
class TaskItemAction extends StatefulWidget {
  final TaskItem taskItem;

  const TaskItemAction({super.key, required this.taskItem});

  @override
  State<StatefulWidget> createState() => _TaskItemActionState();
}

class _TaskItemActionState extends State<TaskItemAction> {

  Future<void> _navToTaskItem(TaskItem item) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => TaskItemPage(inboxItem: item)));
    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 30),
          ActionChip(
            label: Text(widget.taskItem.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )
            ),
            avatar: Icon(Icons.label_outline_rounded),
            onPressed: () => _navToTaskItem(widget.taskItem),
          )
        ],
      );
}

