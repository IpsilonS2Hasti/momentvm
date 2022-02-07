import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:momentvm/models/task.dart';
import '../models/segment_provider.dart';

class TaskScreen extends StatefulWidget {
  final Segment segment;
  final int index;

  TaskScreen({required this.segment, required this.index});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final task = widget.segment.tasks[widget.index];

    titleController.text = task.title;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Today',
          style: TextStyle(color: Colors.black54),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black54,
        ),
        backgroundColor: widget.segment.listColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.segment.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: widget.segment.listColor.withOpacity(0.5),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            labelText: "Title",
                          ),
                          controller: titleController,
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            task.title = titleController.text;
                            widget.segment.updateTasks();
                          },
                          child: const Text('Update Task'),
                        ),
                      ],
                    ),
                  ),
                ),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: widget.segment.listColor.withOpacity(0.5),
                    ),
                    child: Column(
                      children: [],
                    ),
                  ),
                ),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildHeader() {
    //make header widget
    return Container(
      //Segment Header
      height: 45,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Notes:",
                textScaleFactor: 1.2,
              )),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add new note',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
