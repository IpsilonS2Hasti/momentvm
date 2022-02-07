import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:momentvm/models/task.dart';

import '../models/segment_provider.dart';

class NewTaskScreen extends StatefulWidget {
  final Segment segment;

  NewTaskScreen({required this.segment});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    child: Column(children: [
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
                          widget.segment.addTask(Task(titleController.text));
                          Navigator.pop(context);
                        },
                        child: const Text('Create Task'),
                      ),
                    ]),
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
}
