import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  late QuillController notesController;
  final titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String dropdownValue;

  @override
  void initState() {
    titleController.text = widget.segment.tasks[widget.index].title;
    var myJSON = jsonDecode(widget.segment.tasks[widget.index].notes);
    notesController = QuillController(
        document: Document.fromJson(myJSON),
        selection: TextSelection.collapsed(offset: 0));
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
        title: Row(
          children: const [
            Icon(Icons.format_list_numbered_rtl_rounded, color: Colors.black54),
            Text(
              ' My Routine',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
        iconTheme: const IconThemeData(
          color: Colors.black54,
        ),
        backgroundColor: selSeg.listColor,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentNode = FocusScope.of(context);
          if (currentNode.focusedChild != null &&
              !currentNode.hasPrimaryFocus) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: AnimatedSwitcher(
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
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                            Row(
                              children: [
                                Expanded(
                                  child: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'The title must not be empty';
                                        }
                                        if (!value.contains(RegExp(
                                            r'^(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'))) {
                                          return 'The title of a published task must begin with an emoji';
                                        }
                                        if (value.length > 80) {
                                          return 'A title must be no more than 80 characters long';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        labelText: "Title",
                                      ),
                                      controller: titleController,
                                    ),
                                  ),
                                ),
                              ],
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
                                    print(newValue);
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                  },
                                  items: [
                                    ...segments
                                        .where((e) => e.index != 4)
                                        .toList()
                                  ].map<DropdownMenuItem<String>>(
                                      (Segment seg) {
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
                                String curTitle = titleController.text;
                                if (curTitle.length > 80)
                                  curTitle = curTitle.substring(0, 80);
                                task.title = curTitle;
                                task.notes = jsonEncode(notesController.document
                                    .toDelta()
                                    .toJson());
                                widget.segment.updateTask(task);
                                if (widget.segment != selSeg) {
                                  if (selSeg.index == 5) {
                                    task.isCompleted = false;
                                  }
                                  widget.segment.tasks.remove(task);
                                  widget.segment.updateSegment();
                                  selSeg.tasks.insert(0, task);
                                  selSeg.updateSegment();
                                }
                                Navigator.pop(context, {"newSegment": selSeg});
                              },
                              child: const Text('Save Changes'),
                            ),
                            const Divider(
                              height: 3,
                              thickness: 1,
                              indent: 55,
                              endIndent: 55,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () {
                                    widget.segment.deleteTask(task);
                                    Navigator.pop(
                                        context, {"newSegment": selSeg});
                                  },
                                  child: const Text('Delete',
                                      style:
                                          TextStyle(color: Colors.redAccent)),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      FirebaseFirestore firestore =
                                          FirebaseFirestore.instance;
                                      final QuerySnapshot querySnapshot =
                                          await firestore
                                              .collection("published_tasks")
                                              .get();
                                      for (dynamic element
                                          in querySnapshot.docs.toList()) {
                                        if (element["title"] ==
                                            titleController.text) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Such a Task already exists!')),
                                          );
                                          return;
                                        }
                                      }
                                      var uid = context.read<User>().uid;
                                      var newTaskRef = firestore
                                          .collection('/published_tasks')
                                          .doc();
                                      newTaskRef.set({
                                        "title": titleController.text,
                                        "popularity": 1
                                      });
                                      firestore.doc('/users/$uid').update({
                                        "Published":
                                            FieldValue.arrayUnion([newTaskRef])
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Processing Data')),
                                      );
                                    }
                                  },
                                  child: const Text('Publish',
                                      style:
                                          TextStyle(color: Colors.deepPurple)),
                                ),
                              ],
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
                                  Theme(
                                    data: ThemeData(
                                      canvasColor: Colors.transparent,
                                    ),
                                    child: QuillToolbar.basic(
                                      controller: notesController,
                                      showCodeBlock: false,
                                      showInlineCode: false,
                                      multiRowsDisplay: false,
                                      iconTheme: const QuillIconTheme(
                                        iconUnselectedFillColor:
                                            Colors.transparent,
                                      ),
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
        children: const [
          Text(
            "Notes:",
            textScaleFactor: 1.2,
          )
        ],
      ),
    );
  }
}
