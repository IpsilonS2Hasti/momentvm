import 'package:flutter/material.dart';

import 'task.dart';

class Segment with ChangeNotifier {
  final int index;
  final String name;
  final int start;
  final int end;
  final String backgroundImage;
  final Color listColor;
  List<Task> tasks;

  Segment({
    required this.index,
    required this.start,
    required this.end,
    required this.name,
    required this.backgroundImage,
    required this.listColor,
    required this.tasks,
  });

  // List<Task> get tasks {
  //   return _tasks; //You can mutate individual tasks however, as it returns a new list containing refrences to the them
  // }

  void updateTasks([List<Task>? newTasks]) {
    if (newTasks != null) {
      tasks = newTasks;
    }
    notifyListeners();
  }

  void addTask(Task newTask) {
    tasks.add(newTask);
    notifyListeners();
  }
}
