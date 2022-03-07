import 'dart:ui';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:momentvm/models/task.dart';
import 'package:http/http.dart' as http;
import 'package:momentvm/widgets/task_tile.dart';
import 'package:provider/provider.dart';

import '../models/segment_provider.dart';

class NewTaskScreen extends StatefulWidget {
  final Segment segment;

  NewTaskScreen({required this.segment});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final titleController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
            image: AssetImage(widget.segment.backgroundImage),
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
                          print("THE ID IS:" +
                              widget.segment
                                  .addTask(title: titleController.text));
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
            Container(
              margin: const EdgeInsets.all(16),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: widget.segment.listColor.withOpacity(0.5),
                    ),
                    child: Column(children: [
                      buildSearchbar(),
                      buildHeader(),
                      FutureBuilder(
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            var recTasks = snapshot.data as List;
                            return Column(
                                children: recTasks
                                    .map((doc) => buildRecItem(doc))
                                    .toList());
                          }
                          return Text("Loading!");
                        },
                        future: getRecTasks(),
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

  Future<List> getRecTasks() async {
    final QuerySnapshot querySnapshot =
        await firestore.collection("published_tasks").get();
    return querySnapshot.docs.toList();
  }

  Widget buildRecItem(dynamic doc) {
    return Material(
      color: const Color(0x00000000),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.5, color: Color(0x17000000)),
            ),
          ),
          height: 75,
          child: Center(
            child: Row(children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  doc["icon"],
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  doc["title"],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget buildSearchbar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: EdgeInsets.only(right: 15, left: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Color.fromARGB(20, 0, 0, 0),
        ),
        width: 200,
        height: 32,
        child: Row(children: [
          Icon(Icons.search),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: TextField(),
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildHeader() {
    //make header widget
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.5,
            color: Color(0x17000000),
          ),
        ),
      ),
      height: 45,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Recommended:",
              textScaleFactor: 1.2,
            ),
          )
        ],
      ),
    );
  }
}
