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

    Future<void> _navToTaskItem(TaskItem item) async {
      final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => TaskItemPage(inboxItem: item)));
      if (result == true) {
        setState(() {});
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          const Text("You've reached the nextAction area"),
          ...testItems.map((item) =>
            ActionChip(
              label: Text(item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )
              ),
              avatar: Icon(Icons.label_outline_rounded),
              onPressed: () => _navToTaskItem(item),
            ),
          ),
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

  void _navToNextActions() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const NextActionsPage()));
  }

  Future<void> _navToInboxItem(TaskItem item) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => TaskItemPage(inboxItem: item)));
    if (result == true) {
      setState(() {});
    }
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.amber,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
                  onPressed: null,
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 30),
                      ActionChip(
                        label: Text(item.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )
                        ),
                        avatar: Icon(Icons.label_outline_rounded),
                        onPressed: () => _navToInboxItem(item),
                      ),
                    ],
                  )
                ],
              )
          ),
        ],
      ),
    );
  }
}

