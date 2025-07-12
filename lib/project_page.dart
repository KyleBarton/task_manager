import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/app_dependencies.dart';
import 'package:task_manager/result.dart';
import 'package:task_manager/task_item.dart';
import 'package:task_manager/task_item_page.dart';
import 'package:task_manager/task_item_repository.dart';

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
            ..._tasks.where((task) => task.status == TaskStatus.somedayMaybe).map((item) =>
                Column(
                  children: [
                    SizedBox(height: 5),
                    // TODO I think a listtile will be better here:
                    // https://api.flutter.dev/flutter/material/ListTile-class.html
                    Hero(
                        tag: "hero-item-id-${item.id}",
                        child: Card(
                          child: ListTile(
                            title: Text(item.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(item.status.toString()),
                            onTap: () async {
                              final updated = await Navigator.push(context, MaterialPageRoute(builder: (context) => TaskItemPage(item: item)));
                              if (updated == true) {
                                setState((){
                                  _taskItemRepository.update(item);
                                });
                              }
                            },
                          ),
                        )
                    ),
                  ],
                )
            ),
            // TODO
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    // TODO handle result
                    final newItem = _taskItemRepository.create(
                      title: "Enter task title",
                      status: TaskStatus.somedayMaybe,
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
            ),
            Text(
                "Next Actions"
            ),
            ..._tasks.where((task) => task.status == TaskStatus.nextAction).map((item) =>
                Column(
                  children: [
                    SizedBox(height: 5),
                    // TODO I think a listtile will be better here:
                    // https://api.flutter.dev/flutter/material/ListTile-class.html
                    Hero(
                        tag: "hero-item-id-${item.id}",
                        child: Card(
                          child: ListTile(
                            title: Text(item.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(item.status.toString()),
                            onTap: () async {
                              final updated = await Navigator.push(context, MaterialPageRoute(builder: (context) => TaskItemPage(item: item)));
                              if (updated == true) {
                                setState((){
                                  _taskItemRepository.update(item);
                                });
                              }
                            },
                          ),
                        )
                    ),
                  ],
                )
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    // TODO handle result
                    final newItem = _taskItemRepository.create(
                      title: "Enter task title",
                      status: TaskStatus.nextAction,
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
            ),
            Text(
                "Waiting For"
            ),
            ..._tasks.where((task) => task.status == TaskStatus.waitingFor).map((item) =>
                Column(
                  children: [
                    SizedBox(height: 5),
                    // TODO I think a listtile will be better here:
                    // https://api.flutter.dev/flutter/material/ListTile-class.html
                    Hero(
                        tag: "hero-item-id-${item.id}",
                        child: Card(
                          child: ListTile(
                            title: Text(item.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(item.status.toString()),
                            onTap: () async {
                              final updated = await Navigator.push(context, MaterialPageRoute(builder: (context) => TaskItemPage(item: item)));
                              if (updated == true) {
                                setState((){
                                  _taskItemRepository.update(item);
                                });
                              }
                            },
                          ),
                        )
                    ),
                  ],
                )
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    // TODO handle result
                    final newItem = _taskItemRepository.create(
                      title: "Enter task title",
                      status: TaskStatus.waitingFor,
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
            ),
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

}

// TODO this is an interesting idea to pursue later
class NestedTextField extends StatefulWidget {
  const NestedTextField({super.key});

  @override
  State<StatefulWidget> createState() => _NestedTextFieldState();

}

class _NestedTextFieldState extends State<NestedTextField> {
  List<String> lines = [
      "Enter content below",
    ];

  @override
  Widget build(BuildContext context) {
    final fullTextController = TextEditingController(
      text: lines.join("\n"),
    );
    final newSectionController = TextEditingController();
    return Column(
      children: [
        Text(
          lines.join("\n"),
          maxLines: null,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            onPressed: (){
              if (newSectionController.text.isNotEmpty) {
                setState(() {
                  lines.add(newSectionController.text);
                });
              }
            },
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: newSectionController,
                    decoration: InputDecoration(
                      labelText: "Add new Section...",
                      labelStyle: TextStyle(
                        fontSize: 10,
                      )
                    ),
                  ),
                ),
                Icon(Icons.add),
              ],
            )
        )
      ],
    );
    // return TextField(
    //   maxLines: null,
    //   keyboardType: TextInputType.multiline,
    //   decoration: InputDecoration(
    //     labelText: "Enter Text",
    //     floatingLabelAlignment: FloatingLabelAlignment.center,
    //     // suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.add))
    //     suffix: Column(
    //       children: [
    //         Text("Enter new heading"),
    //         IconButton(onPressed: (){}, icon: Icon(Icons.add)),
    //       ],
    //     )
    //   ),
    // );
  }

}