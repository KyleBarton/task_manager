import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_dependencies.dart';
import 'package:task_manager/project_nav_drawer.dart';
import 'package:task_manager/result.dart';
import 'package:task_manager/task_item.dart';
import 'package:task_manager/task_item_repository.dart';
import 'package:task_manager/task_list_widget.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TaskItemRepository taskItemRepository;

  Set<TaskStatus> _activeStatuses = {};

  @override
  void initState() {
    super.initState();
    final appDependencies = context.appDependencies();
    taskItemRepository = appDependencies.taskItemRepository;
    taskItemRepository.createInitialTasks();
  }

  final Map<TaskStatus, IconData> _statusIcons = {
    TaskStatus.inbox: Icons.inbox_rounded,
    TaskStatus.nextAction: Icons.check_box_rounded,
    TaskStatus.waitingFor: Icons.watch_rounded,
    TaskStatus.somedayMaybe: Icons.ac_unit_rounded,
  };

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
                  taskItemRepository.create(title: value).expect();
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

  _onDestinationSelected(
      int index,
      List<ProjectNavOption> projects,
      ) {
    setState(() {
      _screenIndex = index;
      if (index <= 0) {
        _projectName = null;
      }
      else {
        // Ugh this logic is hard
        _projectName = projects[index-1].title;
      }
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      Navigator.of(context).pop();
    });
  }

  List<ProjectNavOption> _displayProjects() {
    return taskItemRepository.getAll().expect()
        .map((t) => t.project)
        .where((p) => p != null && p != "")
        .toSet()
        .map((projectName) => ProjectNavOption(title: projectName!))
        .toList();
  }

  @override
  Widget build(BuildContext context) {

    List<ProjectNavOption> projects = _displayProjects();
    if (!projects.any((p) => p.title == _projectName)) {
      _projectName = null;
      _screenIndex = 0;
      // Gotta call it again because I've changed _projectName. Ugh
    } else {
      _screenIndex = projects.indexWhere((p) => p.title == _projectName) + 1;
    }

    var pageTitle = _projectName ?? "All Tasks";

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(pageTitle),
      ),
      drawer: ProjectNavDrawer(
          screenIndex: _screenIndex,
          onDestinationSelected: ((index) => _onDestinationSelected(index, projects)),
          projectNavOptions: projects,
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
            onSelectionChanged: (Set<TaskStatus> newSelection) {
              setState(() {
                _activeStatuses = newSelection;
              });
            },
            showSelectedIcon: false,
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
            selected: _activeStatuses,
            emptySelectionAllowed: true,
            multiSelectionEnabled: true,
          ),
          SizedBox(height: 25),
          Expanded(
            child: taskListView(
              _activeTasks(_activeStatuses, _projectName),
              context,
              ((item) => setState((){
                taskItemRepository.update(item);
                _activeStatuses = {item.status};
                _projectName = item.project;
              })),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCaptureModal,
        tooltip: 'Add to Inbox',
        child: const Icon(Icons.add),
      ),
    );
  }

  List<TaskItem> _activeTasks(
      Set<TaskStatus> activeStatuses,
      String? selectedProject,
      ) {
    // TODO order by: inbox, nextAction, waitingFor, someday/Maybe
    // TODO order by project as well?
    return taskItemRepository.getAll()
        .expect() // TODO handle error
        .where((item) => activeStatuses.contains(item.status) || _activeStatuses.isEmpty)
        .where((item) => item.project == selectedProject || selectedProject == null).toList();
  }
}