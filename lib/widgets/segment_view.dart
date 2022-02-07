import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:momentvm/models/task.dart';
import 'package:momentvm/screens/new_task_screen.dart';
import 'package:momentvm/screens/task_screen.dart';
import 'package:momentvm/widgets/task_tile.dart';
import 'package:provider/provider.dart';

import '../models/segment_provider.dart';
import '../screens/new_task_screen.dart';
import './time_tracker.dart';

class SegmentView extends StatelessWidget {
  SegmentView({Key? key}) : super(key: key); //was const before controller

  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    final segment = Provider.of<Segment>(context);
    return SizedBox(
      child: Column(
        children: [
          TimeTracker(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: segment.listColor.withOpacity(0.75),
                    ),
                    child: Column(
                      children: [
                        buildHeader(segment, context),
                        Expanded(
                          child: segment.tasks.isEmpty
                              ? Text("Empty!")
                              : ReorderableListView.builder(
                                  scrollController: _controller,
                                  itemCount: segment.tasks.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          TaskTile(
                                    segment: segment,
                                    index: index,
                                    key: ValueKey(
                                        segment.tasks[index]), //change to id
                                  ),
                                  onReorder: (int oldIndex, int newIndex) {
                                    if (oldIndex < newIndex) {
                                      newIndex -=
                                          1; //This is necessary because newIndex is the new position before we remove the old element, but after that operation, the list gets smaller by 1
                                    }
                                    final item =
                                        segment.tasks.removeAt(oldIndex);
                                    segment.tasks.insert(newIndex, item);
                                    segment.updateTasks();
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
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
