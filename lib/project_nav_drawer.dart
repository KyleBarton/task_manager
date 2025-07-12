import 'package:flutter/material.dart';
import 'package:task_manager/project_page.dart';

class ProjectNavOption {
  const ProjectNavOption({
    required this.title,
    this.icon = Icons.build_outlined,
    this.selectedIcon = Icons.build,
  });

  const ProjectNavOption.allTasks({
    this.title = "All Tasks",
    this.icon = Icons.all_inbox_outlined,
    this.selectedIcon = Icons.all_inbox,
  });
  final String title;
  final IconData icon;
  final IconData selectedIcon;
}

class ProjectNavDrawer extends StatelessWidget {

  const ProjectNavDrawer({
    super.key,
    required this.screenIndex,
    required this.onDestinationSelected,
    required this.projectNavOptions,
  });
  final List<ProjectNavOption> projectNavOptions;
  final int screenIndex;
  final void Function(int) onDestinationSelected;


  NavigationDrawerDestination _navDrawerProjectOption(
    ProjectNavOption navOption,
  ) =>
      NavigationDrawerDestination(
          icon: Icon(navOption.icon),
          selectedIcon: Icon(navOption.selectedIcon),
          label: SizedBox(
              width: 175,
              child: Text(
                navOption.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              )
          )
      );

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: onDestinationSelected,
      selectedIndex: screenIndex,
      children: [
        _navDrawerProjectOption(ProjectNavOption.allTasks()),
        const Padding(
          padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: Divider(),
        ),
        ...projectNavOptions.map((navOption) => _navDrawerProjectOption(navOption)),
        const Padding(
          padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: Divider(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectPage()));
              },
              child: Row(
                children: [
                  Text("New "),
                  Icon(Icons.add)
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

}