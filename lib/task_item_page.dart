import 'package:flutter/material.dart';
import 'package:task_manager/task_item.dart';


// Ok, clients need a couple of niceties here:
// focusTitle - whether to put the cursor on the title at start
// allowInbox - whether to allow the item to be in an inbox status (default to true). Should be false when called from a project perspective
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

  final Map<TaskStatus, IconData> _statusIcons = {
    TaskStatus.inbox: Icons.inbox_rounded,
    TaskStatus.nextAction: Icons.check_box_rounded,
    TaskStatus.waitingFor: Icons.watch_rounded,
    TaskStatus.somedayMaybe: Icons.ac_unit_rounded,
  };

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
            style: SegmentedButton.styleFrom(
              animationDuration: Duration(seconds: 1),
              backgroundColor: Colors.white,
              selectedBackgroundColor: Colors.amber,
              iconSize: 30.0,
              padding: EdgeInsetsGeometry.only(left: 10.0),
            ),
            segments: [
              ButtonSegment(
                value: TaskStatus.inbox,
                label: Text(""),
                icon: Icon(_statusIcons[TaskStatus.inbox]),
              ),
              ButtonSegment(
                value: TaskStatus.nextAction,
                label: Text(""),
                icon: Icon(_statusIcons[TaskStatus.nextAction]),
              ),
              ButtonSegment(
                value: TaskStatus.waitingFor,
                label: Text(""),
                icon: Icon(_statusIcons[TaskStatus.waitingFor]),
              ),
              ButtonSegment(
                value: TaskStatus.somedayMaybe,
                label: Text(""),
                icon: Icon(_statusIcons[TaskStatus.somedayMaybe]),
              ),
            ],
            selected: {taskItem.status},
            emptySelectionAllowed: false,
            showSelectedIcon: false,
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
