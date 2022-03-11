import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'task.dart';

class Segment with ChangeNotifier {
  final String uid;
  final int index;
  final String name;
  final int start;
  final int end;
  final String backgroundImage;
  final Color listColor;
  List<Task> tasks = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Segment({
    required this.uid,
    required this.index,
    required this.start,
    required this.end,
    required this.name,
    required this.backgroundImage,
    required this.listColor,
  }) {
    firestore.doc('/users/$uid').get().then(
      (value) {
        try {
          List refArr = value.get(FieldPath([name]));
          print(refArr);
          for (int i = 0; i < refArr.length; i++) {
            refArr[i].get().then(
              (value) {
                tasks.add(Task(
                  id: value.id,
                  title: value.get("title"),
                  notes: value.get("notes"),
                  isCompleted: value.get("isCompleted"),
                ));
                notifyListeners();
              },
            );
          }
        } on StateError catch (e) {
          print('No nested field exists!');
        }
      },
    );
  }

  // List<Task> get tasks {
  //   return _tasks; //You can mutate individual tasks however, as it returns a new list containing refrences to the them
  // }

  void updateTask(Task newTask) {
    firestore.doc('/users/$uid/tasks/${newTask.id}').update({
      "title": newTask.title,
      "notes": newTask.notes,
      "isCompleted": newTask.isCompleted
    }); //Needs to be manually adjusted every time, use converter instead
    notifyListeners();
  }

  String addTask({required String title}) {
    var newTaskRef = firestore.collection('/users/$uid/tasks').doc();
    firestore.doc('/users/$uid').update({
      name: FieldValue.arrayUnion([newTaskRef])
    });
    Task newTask = Task(id: newTaskRef.id, title: title);
    newTaskRef
        .set({"title": title, "isCompleted": false, "notes": newTask.notes});
    tasks.add(newTask);
    notifyListeners();
    return newTaskRef.id;
  }

  void deleteTask(Task delTask) {
    firestore.doc('/users/$uid/tasks/${delTask.id}').delete();
    tasks.remove(delTask);
    firestore.doc('/users/$uid').update({
      name:
          tasks.map((e) => firestore.doc('/users/$uid/tasks/${e.id}')).toList(),
    });
    notifyListeners();
  }

  void reorderTasks({required int newIndex, required int oldIndex}) {
    if (oldIndex < newIndex) {
      newIndex -=
          1; //This is necessary because newIndex is the new position before we remove the old element, but after that operation, the list gets smaller by 1
    }
    final item = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, item);
    firestore.doc('/users/$uid').update({
      name:
          tasks.map((e) => firestore.doc('/users/$uid/tasks/${e.id}')).toList(),
    });
    notifyListeners();
  }

  void updateSegment() {
    firestore.doc('/users/$uid').update({
      name:
          tasks.map((e) => firestore.doc('/users/$uid/tasks/${e.id}')).toList(),
    });
    notifyListeners();
  }
}
