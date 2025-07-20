import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/task_item.dart';
import 'package:task_manager/task_item_page.dart';

Widget taskListView(
    List<TaskItem> tasks,
    BuildContext context,
    void Function(TaskItem) stateCallback,
    ) =>
    ListView(
      shrinkWrap: true,
      children: <Widget>[
        ...tasks.map((item) =>
        Column(
          children: [
            SizedBox(height: 5),
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
                        stateCallback(item);
                      }
                    },
                  ),
                )
            ),
          ],
        )
        ),
      ],
    );