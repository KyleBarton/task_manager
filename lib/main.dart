import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Ok, next steps:
// - Take what you did with Inbox and make it re-usable for NextActions and Waiting For
// - Start adding a Dart repository layer that's separate from the Widgets
// - Add testing
// - Implement TODO statuses and make a good animation strategy for that
// - Find a place for Projects?

void main() {
  runApp(const MyApp());
}

// Just keeping these as strings for now, they can be designed better later
// TODO needs its actual state (e.g. IN, NEXTACTION, etc)
class TaskItem {
  TaskItem(this.title);
  String title;
  String? content;
  String? project;
  String? category;
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

// TODO make this stateful eventually
class NextActionsPage extends StatefulWidget {
  final String title;

  const NextActionsPage({super.key, this.title = "Next Actions"});

  @override
  State<StatefulWidget> createState() => _NextActionsState();
}

class _NextActionsState extends State<NextActionsPage> {
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
          const Text("NextAction1"),
          const Text("NextAction2"),
          const Text("NextAction3"),
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
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => InboxPage(inboxItem: item)));
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

class InboxPage extends StatefulWidget {
  final TaskItem inboxItem;
  const InboxPage({super.key, required this.inboxItem});

  @override
  State<StatefulWidget> createState() => _InboxPageState();
}

// TODO should you be able to edit title? Probably
class _InboxPageState extends State<InboxPage> {
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
