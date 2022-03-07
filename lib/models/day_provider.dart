import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'segment_provider.dart';
import 'task.dart';

class Day {
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
  ];
  late final throughout = Segment(
    uid: uid,
    index: 3,
    start: 0,
    end: 0,
    name: "Throughout",
    backgroundImage: "assets/T.png",
    listColor: Colors.white.withOpacity(0.7),
  );

  Day(this.uid);

  List<Segment> get segments {
    return [..._segments];
  }
}
