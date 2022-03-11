import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:momentvm/widgets/task_tile.dart';
import 'package:provider/provider.dart';

import '../models/day_provider.dart';
import '../models/segment_provider.dart';
import '../screens/new_task_screen.dart';

class ThroughoutView extends StatelessWidget {
  final PageController dayController;

  const ThroughoutView({Key? key, required this.dayController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final segment = Provider.of<Segment>(context);
    return Container(
      child: ReorderableListView.builder(
        itemCount: segment.tasks.length,
        itemBuilder: (BuildContext context, int index) => TaskTile(
          dayController: dayController,
          segment: segment,
          index: index,
          key: ValueKey(segment.tasks[index].id),
        ),
        onReorder: (int oldIndex, int newIndex) {
          segment.reorderTasks(
            oldIndex: oldIndex,
            newIndex: newIndex,
          );
        },
      ),
    );
  }
}
