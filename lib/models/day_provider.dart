//Perhaps reduntant
import 'package:flutter/material.dart';

import 'segment_provider.dart';
import 'task.dart';

class Day {
  final List<Segment> _segments = [
    Segment(
        index: 0,
        name: "Morning",
        start: 480,
        end: 720,
        backgroundImage: "assets/M.jpg",
        listColor: const Color(0xFFFFECAF),
        tasks: [Task("Testing")]),
    Segment(
      index: 1,
      start: 720,
      end: 960,
      name: "Afternoon",
      backgroundImage: "assets/A.png",
      listColor: const Color(0xFFC9FFB2),
      tasks: [],
    ),
    Segment(
      index: 2,
      start: 960,
      end: 1200,
      name: "Evening",
      backgroundImage: "assets/E.png",
      listColor: const Color(0xFFFFC1AA),
      tasks: [],
    ),
    Segment(
      index: 3,
      start: 1200,
      end: 1440,
      name: "Night",
      backgroundImage: "assets/N.png",
      listColor: const Color(0xFFB5A8F4),
      tasks: [],
    )
  ];

  List<Segment> get segments {
    return [..._segments];
  }
}
