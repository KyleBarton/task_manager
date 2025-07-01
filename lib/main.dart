import 'package:flutter/material.dart';
import 'package:task_manager/task_item.dart';
import 'package:task_manager/task_item_page.dart';

// Ok, next steps:
// - Take what you did with Inbox and make it re-usable for NextActions and Waiting For
// - Start adding a Dart repository layer that's separate from the Widgets
// - Add testing
// - Implement TODO statuses and make a good animation strategy for that
// - Find a place for Projects?

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: const MyHomePage(title: 'Task Management (WIP)'),
    );
  }
}

class TaskItemsSummaryPage extends StatefulWidget {
  final String title;
  final List<TaskItem> taskItems;
  const TaskItemsSummaryPage({super.key, required this.title, required this.taskItems});

  @override
  State<StatefulWidget> createState() => _TaskItemsSummaryPageState();
}

class _TaskItemsSummaryPageState extends State<TaskItemsSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Row(children: [
            // TODO probably want to solve this with containers in actuality
            SizedBox(width: 25),
            Icon(Icons.inbox_rounded, size: 40,),
            Text(widget.title, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),)
          ],),
          ...widget.taskItems.map((item) =>
              TaskItemAction(taskItem: item)),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("Back"))
        ],
      ),
    );
  }
}

class NextActionsPage extends StatefulWidget {
  final String title;

  const NextActionsPage({super.key, this.title = "Next Actions"});

  @override
  State<StatefulWidget> createState() => _NextActionsState();
}

class _NextActionsState extends State<NextActionsPage> {

  final List<TaskItem> testItems = [
    TaskItem("Next Action 1"),
    TaskItem("Next Action 2"),
    TaskItem("Next Action 3"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          const Text("You've reached the nextAction area"),
          ...testItems.map((item) =>
            TaskItemAction(taskItem: item)),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("Back"))
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<TaskItem> _inboxItems = [];

  final List<TaskItem> _testNextActions = [
    TaskItem("Next Action 1"),
    TaskItem("Next Action 2"),
    TaskItem("Next Action 3"),
  ];
  final List<TaskItem> _testWaitingFors = [
    TaskItem("Waiting For 1"),
    TaskItem("Waiting For 2"),
    TaskItem("Waiting For 3"),
  ];

  void _navToNextActions() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TaskItemsSummaryPage(title: "Next Actions", taskItems: _testNextActions)));
  }

  void _navToWaitingFors() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TaskItemsSummaryPage(title: "Waiting For", taskItems: _testWaitingFors)));
  }

  void _showInboxModal() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Add"),
            content: TextField(
              autofocus: true,
              onSubmitted: (value) {
                Navigator.of(context).pop();
                setState(() {
                  var newInboxItem = TaskItem(value);
                  _inboxItems.add(newInboxItem);
                });
                final snackBar = SnackBar(content: const Text("Added to Inbox"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: _navToNextActions,
                  child: Text("Next Actions")),
              ElevatedButton(
                  onPressed: _navToWaitingFors,
                  child: Text("Waiting For")),
              ElevatedButton(
                  onPressed: null,
                  child: Text("Projects")),
            ],
          ),
          SizedBox(height: 50),
          inboxDialog()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showInboxModal,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Center inboxDialog() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(children: [
            // TODO probably want to solve this with containers in actuality
            SizedBox(width: 25),
            Icon(Icons.inbox_rounded, size: 40,),
            Text("Inbox", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),)
          ],),
          ..._inboxItems.map((item) =>
              Column(
                children: [
                  SizedBox(height: 5),
                  TaskItemAction(taskItem: item)
                ],
              )
          ),
        ],
      ),
    );
  }
}

