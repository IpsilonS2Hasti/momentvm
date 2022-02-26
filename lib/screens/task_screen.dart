import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:momentvm/models/task.dart';
import 'package:provider/provider.dart';
import '../models/day_provider.dart';
import '../models/segment_provider.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class TaskScreen extends StatefulWidget {
  final Segment segment;
  final int index;

  TaskScreen({required this.segment, required this.index});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  QuillController notesController = QuillController.basic();
  final titleController = TextEditingController();
  late String dropdownValue;

  @override
  void initState() {
    titleController.text = widget.segment.tasks[widget.index].title;
    dropdownValue = widget.segment.index.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final segments = Provider.of<Day>(context).segments;
    var selSeg = segments[int.parse(dropdownValue)];
    final task = widget.segment.tasks[widget.index];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Today',
          style: TextStyle(color: Colors.black54),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black54,
        ),
        backgroundColor: selSeg.listColor,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Container(
          key: ValueKey(selSeg.name),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(selSeg.backgroundImage),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: selSeg.listColor.withOpacity(0.5),
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
                          Row(
                            children: [
                              const Text(
                                "Reschedule:",
                                textScaleFactor: 1.2,
                              ),
                              const SizedBox(width: 16),
                              DropdownButton<String>(
                                dropdownColor: selSeg.listColor,
                                borderRadius: BorderRadius.circular(24),
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_drop_down),
                                elevation: 16,
                                underline: Container(
                                  height: 2,
                                  color: Colors.black26,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                                items: [
                                  ...segments
                                ].map<DropdownMenuItem<String>>((Segment seg) {
                                  return DropdownMenuItem<String>(
                                    value: seg.index.toString(),
                                    child: Text(seg.name),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              task.title = titleController.text;
                              widget.segment.updateTasks();
                              if (widget.segment != selSeg) {
                                widget.segment.tasks.remove(task);
                                selSeg.tasks.insert(0, task);
                              }
                              Navigator.pop(context, {"newSegment": selSeg});
                            },
                            child: const Text('Save Changes'),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: selSeg.listColor.withOpacity(0.5),
                      ),
                      child: Column(
                        children: [
                          buildHeader(),
                          Container(
                            height: 400,
                            child: Column(
                              children: [
                                QuillToolbar.basic(
                                  controller: notesController,
                                  showCodeBlock: false,
                                  showInlineCode: false,
                                  multiRowsDisplay: false,
                                  iconTheme: QuillIconTheme(
                                    iconUnselectedFillColor: Colors.transparent,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: QuillEditor(
                                      scrollController: ScrollController(),
                                      scrollable: true,
                                      focusNode: FocusNode(),
                                      autoFocus: false,
                                      expands: false,
                                      padding: EdgeInsets.zero,
                                      controller: notesController,
                                      readOnly:
                                          false, // true for view only mode
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ],
          ),
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
