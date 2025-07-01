import 'package:flutter/material.dart' as widgets;
import 'package:provider/provider.dart';
import 'package:task_manager/task_item_repository.dart';

class AppDependencies {
  final TaskItemRepository taskItemRepository;
  const AppDependencies({required this.taskItemRepository});
}

extension AppDependenciesGetter on widgets.BuildContext {
  AppDependencies appDependencies() => Provider.of<AppDependencies>(this, listen: false);
}
