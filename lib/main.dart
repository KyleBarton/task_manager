import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_dependencies.dart';
import 'package:task_manager/project_nav_drawer.dart';
import 'package:task_manager/result.dart';
import 'package:task_manager/task_item.dart';
import 'package:task_manager/task_item_page.dart';
import 'package:task_manager/task_item_repository.dart';

// Ok, next steps:
// - Implement TODO statuses and make a good animation strategy for that

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TaskItemRepository taskItemRepository;

  late final List<ProjectNavOption> _projects;
  List<TaskItem> _activeTasks = [];

  var viewStatus = TaskStatus.inbox;

  @override
  void initState() {
    super.initState();
    final appDependencies = context.appDependencies();
    taskItemRepository = appDependencies.taskItemRepository;
    taskItemRepository.createInitialTasks();

    final List<TaskItem> tasks = taskItemRepository.getAll().expect();
    _activeTasks = tasks;


    _projects = tasks
        .map((t) => t.project)
        .where((p) => p != null)
        .toSet()
        .map((projectName) => ProjectNavOption(title: projectName!))
        .toList();
  }

  Center _centerContent() {
    var items = _activeTasks
        .where((item) => item.status == TaskStatus.inbox)
        .where((item) => item.project == _projectName || _projectName == null);
    var titleRow = Row(children: [
            // TODO probably want to solve this with containers in actuality
            SizedBox(width: 25),
            Icon(Icons.inbox_rounded, size: 40,),
            Text("Inbox", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),)
          ],);
    if (viewStatus == TaskStatus.nextAction) {
      items = _activeTasks
          .where((item) => item.status == TaskStatus.nextAction)
          .where((item) => item.project == _projectName || _projectName == null);
      titleRow = Row(children: [
        // TODO probably want to solve this with containers in actuality
        SizedBox(width: 25),
        Icon(Icons.pending_actions_rounded, size: 40,),
        Text("Next Actions", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),)
      ],);
    }
    if (viewStatus == TaskStatus.waitingFor) {
      items = _activeTasks
          .where((item) => item.status == TaskStatus.waitingFor)
          .where((item) => item.project == _projectName || _projectName == null);
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
                  TaskItemAction(
                    taskItem: item,
                    stateCallback: (taskItem) => setState(() {
                      taskItemRepository.update(taskItem);
                    }),
                  )
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

  void _showCaptureModal() {
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
                  _activeTasks.add(newInboxItem);
                });
                final snackBar = SnackBar(content: const Text("Added to Inbox"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          );
        });
  }

  int _screenIndex = 0;
  String? _projectName;
  _onDestinationSelected(int index) {
    setState(() {
      _screenIndex = index;
      if (index <= 0) {
        _projectName = null;
      }
      else {
        _projectName = _projects[index-1].title;
      }
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(widget.title),
      ),
      drawer: ProjectNavDrawer(
          screenIndex: _screenIndex,
          onDestinationSelected: _onDestinationSelected,
          projectNavOptions: _projects,
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
        onPressed: _showCaptureModal,
        tooltip: 'Add to Inbox',
        child: const Icon(Icons.add),
      ),
    );
  }
}