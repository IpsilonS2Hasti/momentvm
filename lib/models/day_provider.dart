import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'segment_provider.dart';
import 'task.dart';

class Day with ChangeNotifier {
  String uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final List<Segment> _segments = [
    Segment(
      uid: uid,
      index: 0,
      name: "Morning",
      start: 480,
      end: 720,
      backgroundImage: "assets/M.jpg",
      listColor: const Color(0xFFFFECAF),
    ),
    Segment(
      uid: uid,
      index: 1,
      start: 720,
      end: 960,
      name: "Afternoon",
      backgroundImage: "assets/A.png",
      listColor: const Color(0xFFC9FFB2),
    ),
    Segment(
      uid: uid,
      index: 2,
      start: 960,
      end: 1200,
      name: "Evening",
      backgroundImage: "assets/E.png",
      listColor: const Color(0xFFFFC1AA),
    ),
    Segment(
      uid: uid,
      index: 3,
      start: 1200,
      end: 1320,
      name: "Night",
      backgroundImage: "assets/N.png",
      listColor: const Color(0xFFB5A8F4),
    ),
    Segment(
      uid: uid,
      index: 4,
      start: 0,
      end: 0,
      name: "Self Assessment",
      backgroundImage: "assets/S.png",
      listColor: const Color(0xFF6FCDF2),
    ),
    Segment(
      uid: uid,
      index: 5,
      start: 0,
      end: 0,
      name: "Archive",
      backgroundImage: "assets/T.png",
      listColor: const Color(0xFFCFE6F7),
    ),
  ];

  bool dayEnd = false;

  Day(this.uid) {
    DateTime now = DateTime.now();
    final curT = now.hour * 60 + now.minute;
    if (curT >= _segments[0].start) {
      dayEnd = false;
    }
    if (curT >= _segments[3].end) {
      print("Day has ended!");
      dayEnd = true;
    }
    try {
      firestore.collection('/users/$uid/assessments').get().then((value) {
        var date = new DateTime.now();
        final curT = "${date.year}-${date.month}-${date.day}";
        var assessList = value.docs.toList();
        for (var assessment in assessList) {
          if (assessment.data()["date"] == curT) dayEnd = false;
        }
      });
    } on StateError catch (e) {
      print('No collection exists!');
    }
    try {
      firestore.doc('/users/$uid').get().then((value) {
        var date = new DateTime.now();
        final curT = "${date.year}-${date.month}-${date.day}";
        var lastDay = value.get(FieldPath(["lastDay"]));
        if (lastDay != curT) {
          firestore.collection("/users/$uid/tasks").get().then((value) {
            var tasks = value.docs.toList();
            for (var task in tasks) {
              firestore
                  .doc("/users/$uid/tasks/${task.id}")
                  .update({"isCompleted": false});
            }
          });
        }
        firestore.doc('/users/$uid').update({
          "lastDay": curT,
        });
      });
    } on StateError catch (e) {
      print('No collection exists!');
    }
  }

  List<Segment> get segments {
    return [..._segments];
  }

  void endDay() async {
    dayEnd = true;
    await Future.delayed(const Duration(seconds: 2));
    notifyListeners();
  }

  void beginDay() async {
    dayEnd = false;
    notifyListeners();
  }
}
