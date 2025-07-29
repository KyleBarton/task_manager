import 'dart:convert';

import 'package:task_manager/task_item.dart';

class Project {
  String title;

  String purpose;

  String outcomes;

  String brainstorming;

  String organization;

  String referenceData;

  List<TaskItem> tasks;

  int id;

  Project.create({
    required this.title,
    required this.purpose,
    required this.outcomes,
    required this.brainstorming,
    required this.organization,
    required this.referenceData,
    required this.tasks,
    required this.id
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'purpose': purpose,
      'outcomes': outcomes,
      'brainstorming': brainstorming,
      'organization': organization,
      'referenceData': referenceData,
      'tasks': jsonEncode(tasks),
    };
  }
}
