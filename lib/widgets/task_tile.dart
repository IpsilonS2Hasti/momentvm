import 'package:flutter/material.dart';
import 'package:momentvm/screens/task_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

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
          print(newSeg['newSegment'].name);
          if (newSeg != null && newSeg['newSegment'].index != 5)
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
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        segment.tasks[index].title,
                        maxLines: 2,
                        style: segment.tasks[index].isCompleted
                            ? TextStyle(
                                color: Colors.black38,
                                decoration: TextDecoration.lineThrough,
                              )
                            : TextStyle(),
                      ),
                    ),
                  ),
                  if (segment.index != 5)
                    IconButton(
                      padding: kIsWeb
                          ? EdgeInsets.only(right: 35)
                          : EdgeInsets.only(),
                      onPressed: () {
                        segment.tasks[index].isCompleted =
                            !segment.tasks[index].isCompleted;
                        segment.updateTask(segment.tasks[index]);
                      },
                      icon: segment.tasks[index].isCompleted
                          ? const Icon(
                              Icons.check_circle_outline_outlined,
                              color: Colors.black54,
                            )
                          : const Icon(
                              Icons.circle_outlined,
                              color: Colors.black54,
                            ),
                    )
                ]),
          ),
        ),
      ),
    );
  }
}
