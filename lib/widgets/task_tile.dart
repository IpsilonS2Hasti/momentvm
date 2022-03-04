import 'package:flutter/material.dart';
import 'package:momentvm/screens/task_screen.dart';

import '../models/segment_provider.dart';

class TaskTile extends StatelessWidget {
  final int index;
  final Segment segment;
  final PageController dayController;

  const TaskTile({
    Key? key,
    required this.dayController,
    required this.index,
    required this.segment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x00000000),
      key: Key('$index'),
      child: InkWell(
        onTap: () async {
          var newSeg = await Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => TaskScreen(
              segment: segment,
              index: index,
            ),
          ));
          if (newSeg != null)
            dayController.jumpToPage(newSeg['newSegment'].index);
        },
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.5, color: Color(0x17000000)),
            ),
          ),
          height: 75,
          child: Center(
            child: Text(
                segment.tasks[index].title + " id:" + segment.tasks[index].id),
          ),
        ),
      ),
    );
  }
}
