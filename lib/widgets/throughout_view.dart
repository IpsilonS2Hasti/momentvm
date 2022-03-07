import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:momentvm/widgets/task_tile.dart';
import 'package:provider/provider.dart';

import '../models/day_provider.dart';
import '../models/segment_provider.dart';
import '../screens/new_task_screen.dart';

class ThroughoutView extends StatelessWidget {
  final PageController dayController;
  final ScrollController scrollController;

  const ThroughoutView(
      {Key? key, required this.dayController, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final segment = Provider.of<Day>(context).throughout;
    return Container(
      color: Colors.white70,
      child: ReorderableListView.builder(
        scrollController: scrollController,
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

  Container buildHeader(Segment segment, BuildContext context) {
    return Container(
      //Segment Header
      height: 45,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Color(0x0B000000),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                segment.name,
                textScaleFactor: 1.2,
              )),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add new task',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => NewTaskScreen(
                  segment: segment,
                ),
              ));
            },
          ),
        ],
      ),
    );
  }
}
