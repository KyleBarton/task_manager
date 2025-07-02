import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_dependencies.dart';
import 'package:task_manager/result.dart';
import 'package:task_manager/task_item.dart';
import 'package:task_manager/task_item_page.dart';
import 'package:task_manager/task_item_repository.dart';

// Ok, next steps:
// - Implement TODO statuses and make a good animation strategy for that
// - Find a place for Projects?

void main() {
  final TaskItemRepository taskItemRepository = TaskItemRepository();
  runApp(Provider(
    create: (_) => AppDependencies(taskItemRepository: taskItemRepository),
    child: const MyApp(),
  ));
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TaskItemRepository taskItemRepository;

  final List<TaskItem> _inboxItems = [];
  final List<TaskItem> _testNextActions = [];
  final List<TaskItem> _testWaitingFors = [];

  var viewStatus = TaskStatus.inbox;

  @override
  void initState() {
    super.initState();
    final appDependencies = context.appDependencies();
    taskItemRepository = appDependencies.taskItemRepository;

    _testNextActions.add(taskItemRepository.create(title: "Next Action 1").expect());
    _testNextActions.add(taskItemRepository.create(title: "Next Action 2").expect());
    _testNextActions.add(taskItemRepository.create(title: "Next Action 3").expect());

    _testWaitingFors.add(taskItemRepository.create(title: "Waiting For 1").expect());
    _testWaitingFors.add(taskItemRepository.create(title: "Waiting For 2").expect());
    _testWaitingFors.add(taskItemRepository.create(title: "Waiting For 3").expect());
  }

  Center _centerContent() {
    var items = _inboxItems;
    var titleRow = Row(children: [
            // TODO probably want to solve this with containers in actuality
            SizedBox(width: 25),
            Icon(Icons.inbox_rounded, size: 40,),
            Text("Inbox", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),)
          ],);
    if (viewStatus == TaskStatus.nextAction) {
      items = _testNextActions;
      titleRow = Row(children: [
        // TODO probably want to solve this with containers in actuality
        SizedBox(width: 25),
        Icon(Icons.pending_actions_rounded, size: 40,),
        Text("Next Actions", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),)
      ],);
    }
    if (viewStatus == TaskStatus.waitingFor) {
      items = _testWaitingFors;
      titleRow = Row(children: [
        // TODO probably want to solve this with containers in actuality
        SizedBox(width: 25),
        Icon(Icons.timer_rounded, size: 40,),
        Text("Waiting For", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),)
      ],);
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          titleRow,
          ...items.map((item) =>
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
  void _viewInbox() {
    setState(() {
      viewStatus = TaskStatus.inbox;
    });
  }
  void _viewNextActions() {
    setState(() {
      viewStatus = TaskStatus.nextAction;
    });
  }

  void _viewWaitingFor() {
    setState(() {
      viewStatus = TaskStatus.waitingFor;
    });
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
                  var newInboxItem = taskItemRepository.create(title: value).expect();
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
                  onPressed: _viewInbox,
                  child: Text("Inbox")),
              ElevatedButton(
                  onPressed: _viewNextActions,
                  child: Text("Next Actions")),
              ElevatedButton(
                  onPressed: _viewWaitingFor,
                  child: Text("Waiting For")),
            ],
          ),
          SizedBox(height: 50),
          _centerContent(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showInboxModal,
        tooltip: 'Add to Inbox',
        child: const Icon(Icons.add),
      ),
    );
  }
}

