//Perhaps reduntant
import 'package:flutter/material.dart';

import 'segment_provider.dart';
import 'task.dart';

class Day {
  final List<Segment> _segments = [
    Segment(
        name: "Morning",
        start: 480,
        end: 720,
        backgroundImage:
            "https://images.fineartamerica.com/images/artworkimages/mediumlarge/3/sunset-in-the-mountains-abstract-minimalist-art-warm-orange-tones-matthias-hauser.jpg",
        listColor: const Color(0xFFFFECAF),
        tasks: [Task("Testing")]),
    Segment(
      start: 720,
      end: 960,
      name: "Afternoon",
      backgroundImage: "https://wallpapercave.com/wp/wp7528754.jpg",
      listColor: const Color(0xFFC9FFB2),
      tasks: [],
    ),
    Segment(
      start: 960,
      end: 1200,
      name: "Evening",
      backgroundImage:
          "https://cdn.discordapp.com/attachments/802857269796667422/940233623221698670/test.png",
      listColor: const Color(0xFFFFC1AA),
      tasks: [],
    ),
    Segment(
      start: 1200,
      end: 1440,
      name: "Night",
      backgroundImage:
          "https://1.bp.blogspot.com/-ZQiFRfX4vbM/XgtVRmIqHAI/AAAAAAAACTs/Nl0VHZ8UvWUM75qjbVzz-qOUOVJh1f_WACLcBGAsYHQ/s1600/new%2Biphone%2Bwallpaper%2B2.png",
      listColor: const Color(0xFFB5A8F4),
      tasks: [],
    )
  ];

  List<Segment> get segments {
    return [..._segments];
  }
}
