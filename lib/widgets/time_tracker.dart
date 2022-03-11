import 'dart:async';

import 'package:flutter/material.dart';
import 'package:momentvm/models/segment_provider.dart';
import 'package:provider/provider.dart';

import '../models/day_provider.dart';

class TimeTracker extends StatefulWidget {
  @override
  State<TimeTracker> createState() => _TimeTrackerState();
}

class _TimeTrackerState extends State<TimeTracker> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(minutes: 1), (_) {
      print("1 minute has passed");
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final segment = Provider.of<Segment>(context);
    final day = Provider.of<Day>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    final curT = now.hour * 60 + now.minute;
    if (segment.index == 0 &&
        curT >= segment.start &&
        curT <= segment.start + 2) {
      day.beginDay();
    }
    if (segment.index == 3 && curT >= segment.end && curT <= segment.end + 2) {
      print("Day has ended!");
      day.endDay();
    }
    var curTimeWidth =
        (screenWidth * (curT - segment.start)) / (segment.end - segment.start);
    if (curT < segment.start) curTimeWidth = 0; //dispose of the timer
    if (curT > segment.end) curTimeWidth = screenWidth; //dispose of the timer

    return Container(
      height: 20,
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(children: [
        Container(
          height: 20,
          width: screenWidth,
          color: const Color(0x9F90CAF9),
        ),
        Container(
          height: 20,
          width: curTimeWidth,
          color: Colors.blue,
        )
      ]),
    );
  }
}
